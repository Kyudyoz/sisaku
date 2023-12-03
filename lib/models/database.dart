import 'dart:io';

import 'package:drift/drift.dart';
// These imports are used to open the database
import 'package:drift/native.dart';

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

// Rekap

  // Get All Rekaps
  Future<List<Rekap>> getRekaps() async {
    return select(rekaps).get();
  }

  // Ngdapatin Daftar Transaksi (Belum Selesai)
  Future<List<QueryRow>> getTransactionsPerMonth(
      CustomRekap customRekap) async {
    final query = customSelect(
      'SELECT * FROM transactions WHERE transaction_date BETWEEN ? AND ?',
      variables: [
        Variable<DateTime>(customRekap.startDate),
        Variable<DateTime>(customRekap.endDate),
      ],
    );
    return query.get();
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

  // CRUD Create Rekap
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
