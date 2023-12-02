import 'dart:io';

import 'package:drift/drift.dart';
// These imports are used to open the database
import 'package:drift/native.dart';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:sisaku/models/category.dart';
import 'package:sisaku/models/transaction_with_category.dart';
import 'package:sisaku/models/transactions.dart';

part 'database.g.dart';

@DriftDatabase(
  // relative import for the drift file. Drift also supports `package:`
  // imports
  tables: [Categories, Transactions],
)
class AppDb extends _$AppDb {
  AppDb() : super(_openConnection());

  @override
  int get schemaVersion => 1;

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

  // transaksi
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
