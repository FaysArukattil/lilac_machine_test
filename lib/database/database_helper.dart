import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../models/credit_model.dart';
import '../models/expense_model.dart';

class DatabaseHelper {
  DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper._();

  static Database? _db;

  Future<Database> get database async => _db ??= await _init();

  Future<Database> _init() async {
    final path = join(await getDatabasesPath(), 'expenzia.db');
    return openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE transactions(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT NOT NULL,
            amount REAL NOT NULL,
            type TEXT NOT NULL,
            category TEXT NOT NULL DEFAULT 'Other',
            date TEXT NOT NULL,
            description TEXT
          )
        ''');
        await db.execute('''
          CREATE TABLE credits(
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            credit_type TEXT NOT NULL,
            to_name TEXT NOT NULL,
            amount REAL NOT NULL,
            plan_type TEXT NOT NULL,
            date TEXT NOT NULL
          )
        ''');
      },
      onUpgrade: (db, oldVersion, newVersion) async {
        if (oldVersion < 2) {
          await db.execute(
            "ALTER TABLE transactions ADD COLUMN category TEXT NOT NULL DEFAULT 'Other'",
          );
          await db.execute(
            'ALTER TABLE transactions ADD COLUMN description TEXT',
          );
        }
      },
    );
  }

  // ---------- Transactions ----------
  Future<int> insertTransaction(ExpenseModel e) async {
    final db = await database;
    return db.insert('transactions', e.toMap());
  }

  Future<List<ExpenseModel>> getTransactions() async {
    final db = await database;
    final rows = await db.query('transactions', orderBy: 'date DESC, id DESC');
    return rows.map(ExpenseModel.fromMap).toList();
  }

  Future<int> updateTransaction(ExpenseModel e) async {
    final db = await database;
    return db.update(
      'transactions',
      e.toMap(),
      where: 'id = ?',
      whereArgs: [e.id],
    );
  }

  Future<int> deleteTransaction(int id) async {
    final db = await database;
    return db.delete('transactions', where: 'id = ?', whereArgs: [id]);
  }

  // ---------- Credits ----------
  Future<int> insertCredit(CreditModel c) async {
    final db = await database;
    return db.insert('credits', c.toMap());
  }

  Future<List<CreditModel>> getCredits() async {
    final db = await database;
    final rows = await db.query('credits', orderBy: 'date ASC, id DESC');
    return rows.map(CreditModel.fromMap).toList();
  }

  Future<int> deleteCredit(int id) async {
    final db = await database;
    return db.delete('credits', where: 'id = ?', whereArgs: [id]);
  }

  // ---------- Clear everything ----------
  Future<void> clearAll() async {
    final db = await database;
    final batch = db.batch();
    batch.delete('transactions');
    batch.delete('credits');
    await batch.commit(noResult: true);
  }
}
