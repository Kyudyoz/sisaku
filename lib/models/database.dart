import 'dart:io';

import 'package:drift/drift.dart';
// These imports are used to open the database
import 'package:drift/native.dart';
import 'package:intl/intl.dart';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sisaku/models/category.dart';
import 'package:sisaku/models/transaction_with_category.dart';
import 'package:sisaku/models/transactions.dart';
import 'package:sisaku/models/rekap.dart';

part 'database.g.dart';

@DriftDatabase(
  // relative import for the drift file. Drift also supports `package:`
  // imports
  tables: [Categories, Transactions, Rekaps],
)
class AppDb extends _$AppDb {
  AppDb() : super(_openConnection());

  @override
  int get schemaVersion => 2;

  Future<int> getTotalAmountForTypeAndDate(int type) {
    final query = customSelect(
      'SELECT SUM(amount) AS totalAmount FROM transactions '
      'WHERE category_id IN ('
      '  SELECT id FROM categories WHERE type = ?'
      ') ',
      variables: [
        Variable.withInt(type),
      ],
      readsFrom: {transactions, categories},
    );

    return query.map((row) => row.read<int>('totalAmount')).getSingle();
  }

  Future<int> countType(int type) {
    final query = customSelect(
      'SELECT COUNT(amount) AS countType FROM transactions '
      'WHERE category_id IN ('
      '  SELECT id FROM categories WHERE type = ?'
      ') ',
      variables: [
        Variable.withInt(type),
      ],
      readsFrom: {transactions, categories},
    );

    return query.map((row) => row.read<int>('countType')).getSingle();
  }

// CRUD
  Future<List<Category>> getAllCategoryRepo(int type) async {
    return await (select(categories)..where((tbl) => tbl.type.equals(type)))
        .get();
  }

  Future<Map<String, double>> getMapFromDatabase() async {
    // Lakukan query select
    final List<Transaction> results = await select(transactions).get();

    // Buat map kosong
    Map<String, double> dataMap = {};

    // Iterasi hasil query
    for (Transaction transaction in results) {
      // Masukkan data ke dalam map
      dataMap[transaction.name] = transaction.amount.toDouble();
    }

    return dataMap;
  }

  Stream<List<TransactionWithCategory>> getGallery(int type) {
    // Lakukan query select
    final query = (select(transactions).join([
      innerJoin(
        categories,
        categories.id.equalsExp(transactions.category_id),
      ),
    ])
      ..where(categories.type.equals(type))
      ..where(transactions.image.isNotNull()));

    return query.watch().map((rows) {
      return rows.map((row) {
        return TransactionWithCategory(
          row.readTable(transactions),
          row.readTable(categories),
        );
      }).toList();
    });
  }

  Future insertTransaction(int amount, DateTime date, String deskripsi,
      int categoryId, Uint8List? imageDb) async {
    DateTime now = DateTime.now();
    return into(transactions).insertReturning(
      TransactionsCompanion(
        name: Value(deskripsi), // Gunakan Value() untuk setiap parameter
        category_id: Value(categoryId),
        transaction_date: Value(date),
        amount: Value(amount),
        createdAt: Value(now),
        updatedAt: Value(now),
        image: imageDb != null
            ? Value(imageDb)
            : Value.absent(), // Periksa apakah gambar null
      ),
    );
  }

// Update
  Future updateCategoryRepo(int id, String name) async {
    return (update(categories)..where((tbl) => tbl.id.equals(id))).write(
      CategoriesCompanion(name: Value(name)),
    );
  }

  Future updateTransactionRepo(int id, int amount, int categoryId,
      DateTime transactionDate, String deskripsi, Uint8List? imageDb) async {
    return (update(transactions)..where((tbl) => tbl.id.equals(id))).write(
      TransactionsCompanion(
        name: Value(deskripsi),
        amount: Value(amount),
        category_id: Value(categoryId),
        transaction_date: Value(transactionDate),
        image: imageDb != null ? Value(imageDb) : Value.absent(),
      ),
    );
  }

// Delete
  Future deleteCategoryRepo(int id) async {
    return (delete(categories)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future deleteTransactionRepo(int id) async {
    return (delete(transactions)..where((tbl) => tbl.id.equals(id))).go();
  }

  Future deleteCategoryAndTransactionsRepo(int id) async {
    // Hapus kategori
    await (delete(categories)..where((tbl) => tbl.id.equals(id))).go();

    await (delete(transactions)..where((tbl) => tbl.category_id.equals(id)))
        .go();
    return;
  }

  Future deleteAll() async {
    await delete(transactions).go();
    await delete(categories).go();
    await delete(rekaps).go();
    return;
  }

// Transaksi With Category
  Stream<List<TransactionWithCategory>> getTransactionByDate(DateTime date) {
    final query = (select(transactions).join([
      innerJoin(
        categories,
        categories.id.equalsExp(transactions.category_id),
      ),
    ])
      ..where(transactions.transaction_date.equals(date)));

    return query.watch().map((rows) {
      return rows.map((row) {
        return TransactionWithCategory(
          row.readTable(transactions),
          row.readTable(categories),
        );
      }).toList();
    });
  }

  Future<int> getCategoryTypeById(int categoryId) async {
    final query = customSelect(
      'SELECT DISTINCT categories.type AS type FROM transactions '
      'INNER JOIN categories ON transactions.category_id = categories.id '
      'WHERE transactions.category_id = ?',
      variables: [Variable.withInt(categoryId)],
      readsFrom: {transactions, categories},
    );

    try {
      final result =
          await query.map((row) => row.read<int>('type')).getSingle();

      // Validasi hasil
      if (result != 1 && result != 2) {
        throw Exception('Hasil bukan 1 atau 2');
      }

      return result;
    } catch (e) {
      // Tangkap pengecualian jika tidak dapat menemukan hasil unik
      throw Exception('Invalid category type');
    }
  }

  // Get Category Name by Id(Return String) For Rekaps
  Future<List<Map<String, Object>?>> getIncCatNameByRekaps(
      DateTime start, DateTime end) async {
    
    final query = customSelect(
      'SELECT categories.name AS name, SUM(transactions.amount) AS totalAmount, categories.type AS type '
      'FROM transactions '
      'INNER JOIN categories ON transactions.category_id = categories.id '
      'WHERE transactions.transaction_date BETWEEN ? AND ? '
      'AND categories.type = 1 '
      'GROUP BY categories.name',
      variables: [
        Variable.withDateTime(start),
        Variable.withDateTime(end),
      ],
      readsFrom: {transactions, categories},
    );

    final result = await query.map((row) {
      final name = row.read<String>('name');
      final totalAmount = row.read<int>('totalAmount');
      final type = row.read<int>('type'); // Ganti dengan tipe data yang sesuai
      return {
        'name': name,
        'totalAmount': totalAmount,
        'type': type,
      
      };
    }).get();
    print(
        "===================================================================================================================================================================");
    print("result IncCatName dari database");
    return result;
  }

  // Get Expense Category Name  For Rekaps
  Future<List<Map<String, Object>?>> getExpCatNameByRekaps(
      DateTime start, DateTime end) async {
  

    final query = customSelect(
      'SELECT categories.name AS name, SUM(transactions.amount) AS totalAmount, categories.type AS type '
      'FROM transactions '
      'INNER JOIN categories ON transactions.category_id = categories.id '
      'WHERE transactions.transaction_date BETWEEN ? AND ? '
      'AND categories.type = 2 '
      'GROUP BY categories.name',
      variables: [
        Variable.withDateTime(start),
        Variable.withDateTime(end),
      ],
      readsFrom: {transactions, categories},
    );

    final result = await query.map((row) {
      final name = row.read<String>('name');
      final totalAmount = row.read<int>('totalAmount');
      final type = row.read<int>('type');
      // final isiTipe = row.read<int>('type');
       // Ganti dengan tipe data yang sesuai
      if(type == 2) {
        return {
        'name': name,
        'totalAmount': totalAmount,
        'type': type,
       };
      } 
     
      
    }).get();
    
    print(
        "===================================================================================================================================================================");
    print("result dari database");
    return result;
  }

  // Get All Transaction Name  by Rekaps Group Order By Latest
  Stream<List<TransactionWithCategory>> getTransactionByRekaps(DateTime start, DateTime end) {
    final query = (select(transactions).join([
      innerJoin(
        categories,
        categories.id.equalsExp(transactions.category_id),
      ),
    ])
      ..where(transactions.transaction_date.isBetweenValues(start, end))
      ..orderBy([OrderingTerm.asc(transactions.transaction_date)]));
      
    return query.watch().map((rows) {
      return rows.map((row) {
        return TransactionWithCategory(
          row.readTable(transactions),
          row.readTable(categories),
        );
      }).toList();
    });
  }

  // Get All Transaction Name  by Rekaps Group Order By 

// Rekap

  // Get All Rekaps
  Stream<List<Rekap>> getAllRekaps() {
    return select(rekaps).watch();
  }

  // Ngdapatin Daftar Transaksi PerBulan
  Future<List<Rekap>> getSingleRekaps(int id) async {
    return await (select(rekaps)..where((tbl) => tbl.id.equals(id))).get();
  }

// Ngdapatin Daftar Custom Rekaps
  Stream<List<Rekap>> getCustomRekaps() {
    final query = select(rekaps)..where((tbl) => tbl.isMonthly.equals(false));
    return query.watch();
  }

  // Ngdapatin Daftar Transaksi PerBulan
  Stream<List<Rekap>> getMonthlyRekaps() {
    final query = select(rekaps)..where((tbl) => tbl.isMonthly.equals(true));
    return query.watch();
  }

  Future<void> createMonthlyRekaps(int year, int month) async {
    // Hitung jumlah hari dalam bulan dan tahun tertentu
    final lastDay = DateTime(year, month + 1, 0);
    final daysInMonth = lastDay.day;

    // Tentukan rentang tanggal awal dan akhir untuk bulan tersebut
    final startDate = DateTime(year, month, 1);
    final endDate = DateTime(year, month, daysInMonth);

    // Fungsi Untuk Mendapatkan Nama Bulan
    String getMonthNameIndonesian(int month) {
      final startOfMonth = DateTime(year, month, 1);
      final endOfMonth = DateTime(year, month + 1, 0);

      final dateFormat = DateFormat.yMMMMd('id_ID');
      var result =
          '${dateFormat.format(startOfMonth)} - ${dateFormat.format(endOfMonth)}';
      return result;
    }

    // Ambil transaksi dalam rentang waktu tersebut
    final transactions = await getTransactionsInDateRange(startDate, endDate);

    // Jika ada transaksi, lakukan perhitungan dan masukkan ke dalam tabel Rekap
    if (transactions.isNotEmpty) {
      final monthName = getMonthNameIndonesian(month);
      await insertMonthlyRekap(monthName, startDate, endDate);
    }
    // await getMonthlyRekaps();
  }

  // CRUD Create Monthly Rekap
  Future insertMonthlyRekap(
      String monthName, DateTime startDate, DateTime endDate) async {
    DateTime now = DateTime.now();

    // Periksa apakah rekap dengan nama tersebut sudah ada
    final existingRekap = await (select(rekaps)
          ..where((rekap) => rekap.name.equals(monthName)))
        .getSingleOrNull();

    // Jika rekap sudah ada, keluar dari fungsi
    if (existingRekap != null) {
      return;
    }

    // Ambil hasil transaksi dalam rentang tanggal yang diberikan
    final getTransactions =
        await getTransactionsInDateRange(startDate, endDate);

    getCategoryType(categoryId) async {
      final type = await getCategoryTypeById(categoryId);
      return type;
    }

    print(rekaps.name);
    // Hitung jumlah transaksi, pengeluaran, pemasukan, rata-rata pengeluaran, dan rata-rata pemasukan
    int totalTransactions = getTransactions.length;
    int totalExpense = 0;
    int totalIncome = 0;
    int countExpense = 0;
    int countIncome = 0;
// List untuk menyimpan nilai amount
    print("Dari Tanggal : " +
        startDate.toString() +
        " Sampai " +
        endDate.toString());
    // print("isi data" + getTransactions.toString());
    print("Banyak Transaksi : " + totalTransactions.toString());

    for (var transaction in getTransactions) {
      print("isi data" + transaction.data.toString());
      print("Transaksi : " + transaction.data.toString());
      int amount = transaction.data["amount"];

      // Ngedapatin Amount
      print("isi amount" + amount.toString());
      int idCategory = transaction.data["category_id"];

      // Ngedapatin id Category dari category Id
      var type = await getCategoryType(idCategory);

      print("isi Type " + type.toString());
      if (type == 1) {
        // Pemasukan
        totalIncome += amount;
        countIncome++;
      } else if (type == 2) {
        // Pengeluaran
        totalExpense += amount;
        countExpense++;
      }
    }

    double averageExpense = countExpense == 0 ? 0 : totalExpense / countExpense;
    double averageIncome = countIncome == 0 ? 0 : totalIncome / countIncome;

    int sisa = totalIncome - totalExpense;
    // Insert ke dalam tabel rekaps dengan nilai yang dihitung
    return into(rekaps).insertReturning(
      RekapsCompanion(
        name: Value(monthName),
        startDate: Value(startDate),
        endDate: Value(endDate),
        isMonthly: Value(true),
        createdAt: Value(now),
        updatedAt: Value(now),
        totalTransactions: Value(totalTransactions),
        totalExpense: Value(totalExpense),
        totalIncome: Value(totalIncome),
        sisa: Value(sisa), // Sesuaikan dengan logika aplikasi Anda
        averageExpense: Value(averageExpense),
        averageIncome: Value(averageIncome),
      ),
    );
  }

  // Get Rekaps In Data Range(Custom)
  Future<List<QueryRow>> getTransactionsInDateRange(
      DateTime startDate, DateTime endDate) async {
    final results = await customSelect(
      'SELECT * FROM transactions '
      'WHERE transaction_date BETWEEN ? AND ?',
      variables: [
        Variable<DateTime>(startDate),
        Variable<DateTime>(endDate),
      ],
      readsFrom: {transactions},
    ).get();
    return results;
  }

  

  // CRUD Create Custom Rekap
  Future insertRekap(
      String namaRekap, DateTime startDate, DateTime endDate) async {
    DateTime now = DateTime.now();

    // Ambil hasil transaksi dalam rentang tanggal yang diberikan
    final getTransactions =
        await getTransactionsInDateRange(startDate, endDate);

    getCategoryType(categoryId) async {
      final type = await getCategoryTypeById(categoryId);
      return type;
    }

    print(rekaps.name);
    // Hitung jumlah transaksi, pengeluaran, pemasukan, rata-rata pengeluaran, dan rata-rata pemasukan
    int totalTransactions = getTransactions.length;
    int totalExpense = 0;
    int totalIncome = 0;
    int countExpense = 0;
    int countIncome = 0;
// List untuk menyimpan nilai amount
    print("Dari Tanggal : " +
        startDate.toString() +
        " Sampai " +
        endDate.toString());
    // print("isi data" + getTransactions.toString());
    print("Banyak Transaksi : " + totalTransactions.toString());

    for (var transaction in getTransactions) {
      print("isi data" + transaction.data.toString());
      print("Transaksi : " + transaction.data.toString());
      int amount = transaction.data["amount"];

      // Ngedapatin Amount
      print("isi amount" + amount.toString());
      int idCategory = transaction.data["category_id"];

      // Ngedapatin id Category dari category Id
      var type = await getCategoryType(idCategory);

      print("isi Type " + type.toString());
      if (type == 1) {
        // Pemasukan
        totalIncome += amount;
        countIncome++;
      } else if (type == 2) {
        // Pengeluaran
        totalExpense += amount;
        countExpense++;
      }
    }

    double averageExpense = countExpense == 0 ? 0 : totalExpense / countExpense;
    double averageIncome = countIncome == 0 ? 0 : totalIncome / countIncome;

    int sisa = totalIncome - totalExpense;
    // Insert ke dalam tabel rekaps dengan nilai yang dihitung
    return into(rekaps).insertReturning(
      RekapsCompanion(
        name: Value(namaRekap),
        startDate: Value(startDate),
        endDate: Value(endDate),
        isMonthly: Value(false),
        createdAt: Value(now),
        updatedAt: Value(now),
        totalTransactions: Value(totalTransactions),
        totalExpense: Value(totalExpense),
        totalIncome: Value(totalIncome),
        sisa: Value(sisa), // Sesuaikan dengan logika aplikasi Anda
        averageExpense: Value(averageExpense),
        averageIncome: Value(averageIncome),
      ),
    );
  }

  // CRUD Update Rekap
  Future updateRekap(
      int id, String namaRekap, DateTime startDate, DateTime endDate) async {
    // Ambil hasil transaksi dalam rentang tanggal yang diberikan
    final getTransactions =
        await getTransactionsInDateRange(startDate, endDate);

    getCategoryType(categoryId) async {
      final type = await getCategoryTypeById(categoryId);
      return type;
    }

    // print(rekaps.name);
    // Hitung jumlah transaksi, pengeluaran, pemasukan, rata-rata pengeluaran, dan rata-rata pemasukan
    int totalTransactions = getTransactions.length;
    int totalExpense = 0;
    int totalIncome = 0;
    int countExpense = 0;
    int countIncome = 0;
// List untuk menyimpan nilai amount
    print("Dari Tanggal : " +
        startDate.toString() +
        " Sampai " +
        endDate.toString());
    // print("isi data" + getTransactions.toString());
    print("Banyak Transaksi : " + totalTransactions.toString());

    for (var transaction in getTransactions) {
      // print("isi data" + transaction.data.toString());
      // print("Transaksi : " + transaction.data.toString());
      int amount = transaction.data["amount"];

      // Ngedapatin Amount
      // print("isi amount" + amount.toString());
      int idCategory = transaction.data["category_id"];

      // Ngedapatin id Category dari category Id
      var type = await getCategoryType(idCategory);

      // print("isi Type " + type.toString());
      if (type == 1) {
        // Pemasukan
        totalIncome += amount;
        countIncome++;
      } else if (type == 2) {
        // Pengeluaran
        totalExpense += amount;
        countExpense++;
      }
    }

    double averageExpense = countExpense == 0 ? 0 : totalExpense / countExpense;
    double averageIncome = countIncome == 0 ? 0 : totalIncome / countIncome;

    int sisa = totalIncome - totalExpense;
    // Insert ke dalam tabel rekaps dengan nilai yang dihitung
    return (update(rekaps)..where((tbl) => tbl.id.equals(id))).write(
      RekapsCompanion(
        name: Value(namaRekap),
        startDate: Value(startDate),
        endDate: Value(endDate),
        isMonthly: Value(false),
        totalTransactions: Value(totalTransactions),
        totalExpense: Value(totalExpense),
        totalIncome: Value(totalIncome),
        sisa: Value(sisa), // Sesuaikan dengan logika aplikasi Anda
        averageExpense: Value(averageExpense),
        averageIncome: Value(averageIncome),
      ),
    );
  }

  Future updateRekapAmount(int id, DateTime startDate, DateTime endDate) async {
    // Ambil hasil transaksi dalam rentang tanggal yang diberikan
    final getTransactions =
        await getTransactionsInDateRange(startDate, endDate);

    getCategoryType(categoryId) async {
      final type = await getCategoryTypeById(categoryId);
      return type;
    }

    // print(rekaps.name);
    // Hitung jumlah transaksi, pengeluaran, pemasukan, rata-rata pengeluaran, dan rata-rata pemasukan
    int totalTransactions = getTransactions.length;
    int totalExpense = 0;
    int totalIncome = 0;
    int countExpense = 0;
    int countIncome = 0;
// List untuk menyimpan nilai amount
    print("Dari Tanggal : " +
        startDate.toString() +
        " Sampai " +
        endDate.toString());
    // print("isi data" + getTransactions.toString());
    print("Banyak Transaksi : " + totalTransactions.toString());

    for (var transaction in getTransactions) {
      // print("isi data" + transaction.data.toString());
      // print("Transaksi : " + transaction.data.toString());
      int amount = transaction.data["amount"];

      // Ngedapatin Amount
      // print("isi amount" + amount.toString());
      int idCategory = transaction.data["category_id"];

      // Ngedapatin id Category dari category Id
      var type = await getCategoryType(idCategory);

      // print("isi Type " + type.toString());
      if (type == 1) {
        // Pemasukan
        totalIncome += amount;
        countIncome++;
      } else if (type == 2) {
        // Pengeluaran
        totalExpense += amount;
        countExpense++;
      }
    }

    double averageExpense = countExpense == 0 ? 0 : totalExpense / countExpense;
    double averageIncome = countIncome == 0 ? 0 : totalIncome / countIncome;

    int sisa = totalIncome - totalExpense;
    // Insert ke dalam tabel rekaps dengan nilai yang dihitung
    return (update(rekaps)..where((tbl) => tbl.id.equals(id))).write(
      RekapsCompanion(
        startDate: Value(startDate),
        endDate: Value(endDate),
        totalTransactions: Value(totalTransactions),
        totalExpense: Value(totalExpense),
        totalIncome: Value(totalIncome),
        sisa: Value(sisa), // Sesuaikan dengan logika aplikasi Anda
        averageExpense: Value(averageExpense),
        averageIncome: Value(averageIncome),
      ),
    );
  }

  // CRUD Delete Rekap
  Future deleteRekap(int id) async {
    return (delete(rekaps)..where((tbl) => tbl.id.equals(id))).go();
  }
}

LazyDatabase _openConnection() {
  // the LazyDatabase util lets us find the right location for the file async.
  return LazyDatabase(() async {
    // put the database file, called db.sqlite here, into the documents folder
    // for your app.
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));

    return NativeDatabase.createInBackground(file);
  });
}



// Kode gagal
//   Future<Map<String, List>?> getCategoryNameByRekaps(
//       DateTime start, DateTime end) async {
//     final getTransactions = await getTransactionsInDateRange(start, end);

//     Map<String, List> dataMap = {
//       "incomeName": [],
//       "incomeAmount": [],
//       "expenseName": [],
//       "expenseAmount": []
//     };

//     getCategoryType(categoryId) async {
//       final type = await getCategoryTypeById(categoryId);
//       return type;
//     }

// // Set untuk menyimpan nama kategori yang sudah ada
//     Set<String> uniqueIncomeNames = {};
//     Set<String> uniqueExpenseNames = {};

// // Ngedapatin semua transaksi berdasarkan rekap dan looping

//     for (var transaction in getTransactions) {
//       // Ngedapatin Amount
//       int index = 1;
//       int idCategory = transaction.data["category_id"];
//       // print("isi Id Kategori " + idCategory.toString());

//       // Ngedapatin Amount
//       int amount = transaction.data["amount"];
//       // print("isi Data Amount begini " + amount.toString());

//       // Ngedapatin amount dari setiap kategori
//       int incomeCategory = 0;
//       int expenseCategory = 0;

//       final query = customSelect(
//         'SELECT DISTINCT categories.name AS name FROM transactions '
//         'INNER JOIN categories ON transactions.category_id = categories.id '
//         'WHERE transactions.category_id = ?',
//         variables: [Variable.withInt(idCategory)],
//         readsFrom: {transactions, categories},
//       );

//       // Tes
//       final name =
//           await query.map((row) => row.read<String>('name')).getSingle();
//       // print("Isi nama kategori ==> $name");

//       var type = await getCategoryType(idCategory);

//       List oldDataIncome = uniqueIncomeNames.toList();
//       List oldDataExpense = uniqueExpenseNames.toList();
//       // int tes = uniqueIncomeNames.toList().indexOf(name);
//       // Kalo Pemasukan/Income
//       if (type == 1) {
//         print("Nama Income = $name");
//         print("Unique Income Names: $uniqueIncomeNames");
//         print("Income Amount skrg : " + dataMap["incomeAmount"].toString());
//         int nilaiLama = 0;

//         if (!uniqueIncomeNames.contains(name)) {
//           uniqueIncomeNames.add(name);
//           // Menambah data expenseName
//           incomeCategory += amount;
//           nilaiLama = amount;
//           dataMap["incomeName"]?.add(name);
//           dataMap["incomeAmount"]?.add(incomeCategory);
//         } else {
//           // Jika sudah ada Nama Kategori, tapi transaksi beda, index sebelumnya maka akan diupdate
//           // Tetap ditambahkan
//           int indeks = uniqueIncomeNames.toList().indexOf(name);

//           // String indexLama = indeks.toString();
//           // }
//           // nilaiLama =
//           // Kalo income amount masih kosong otomatis tambahkan tanpa nama
//           if (dataMap["incomeAmount"]!.length == 0) {
//             dataMap["incomeAmount"]?.add(incomeCategory);
//             nilaiLama = amount;
//           }

//           // Tambah dengan nilai lama dengan key index
//           incomeCategory = amount;
//           // final namaKey = oldDataIncome[]
//           nilaiLama = dataMap["incomeAmount"]?[indeks];
//           int totalNilaiBaru = nilaiLama + incomeCategory;
//           dataMap["incomeAmount"]?[indeks] = totalNilaiBaru;

//           final tes = dataMap["incomeAmount"]?[indeks];
//           print("Isi indekss $indeks");
//           print("Isi dataMap[" "] $tes");
//         }
//         print("nilai lama  : $nilaiLama");
//       }

//       // Kalo Pengeluaran
//       else if (type == 2) {
//         print("Nama Expense: $name");
//         print("Unique Expense Names: $uniqueExpenseNames");
//         print("Expense Amount skrg : " + dataMap["expenseAmount"].toString());

//         // Menambahkan amount

// // Untuk menjadikan amountExpense jadi sama index dengan expenseName

//         // Jika nama kategori belum ada dalam Set, tambahkan nama kategori ke Set dan tambahkan ke Map
//         int nilaiLama = 0;
//         if (!uniqueExpenseNames.contains(name)) {
//           uniqueExpenseNames.add(name);
//           // Menambah data expenseName
//           expenseCategory += amount;
//           nilaiLama = amount;
//           dataMap["expenseName"]?.add(name);
//           dataMap["expenseAmount"]?.add(expenseCategory);
//         } else {
//           // Jika sudah ada Nama Kategori, tapi transaksi beda, index sebelumnya maka akan diupdate
//           // Tetap ditambahkan
//           int indeks = uniqueExpenseNames.toList().indexOf(name);
//           // if(dataMap["expenseAmount"]) {

//           // }
//           // nilaiLama =

//           if (dataMap["expenseAmount"]!.length == 0) {
//             dataMap["expenseAmount"]?.add(expenseCategory);
//             nilaiLama = amount;
//           }

//           // Tambah dengan nilai lama dengan key index
//           nilaiLama = oldDataExpense[0];
//           incomeCategory = amount;
//           int totalNilaiBaru = nilaiLama + expenseCategory;
//           dataMap["expenseAmount"]?[indeks] = totalNilaiBaru;

//           final tes = dataMap["expenseAmount"]?[indeks];
//           print("Isi indekss $indeks");
//           print("Isi dataMap[" "] $tes");
//         }
//         print("nilai lama  : $nilaiLama");
//       } else {
//         print("ntahla");
//       }

//       index++;
//     }

//     print("Hasil akhir datamap : === $dataMap");
//     return dataMap;
//   }