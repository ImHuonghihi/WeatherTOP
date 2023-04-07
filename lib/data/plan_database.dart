import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:weather/models/plan.dart';

class PlanDatabase {
  late final _database;

  static Future<PlanDatabase> createFutureInstance() async {
    final database = _initDB('plans.db');
    return PlanDatabase(database: database);
  }

  PlanDatabase({database}) {
    _database = database;
  }
  static Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  static FutureOr<void> _createDB(Database db, int version) {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT NOT NULL';
    const intType = 'INTEGER NOT NULL';
    const tablePlans = 'plans';
    
    return db.execute('''
      CREATE TABLE $tablePlans (
        id $idType,
        title $textType,
        description $textType,
        category $textType,
        date $textType,
        progress $intType,
        isDone $intType
      )
    ''');
  }

  Future<List<Plan>> getPlans() async {
    final db = await _database;
    final res = await db.query('plans');
    return res.isNotEmpty
        ? res.map((e) => Plan.fromMap(e)).toList()
        : <Plan>[];
  }

  Future<int> insertPlan(Plan plan) async {
    final db = await _database;
    return await db.insert('plans', plan.toMap());
  }

  Future<int> updatePlan(Plan plan) async {
    final db = await _database;
    return await db.update(
      'plans',
      plan.toMap(),
      where: 'id = ?',
      whereArgs: [plan.id],
    );
  }

  Future<int> deletePlan(int id) async {
    final db = await _database;
    return await db.delete(
      'plans',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> deleteAllPlans() async {
    final db = await _database;
    return await db.delete('plans');
  }

  Future<int> getPlansCount() async {
    final db = await _database;
    return Sqflite.firstIntValue(
      await db.rawQuery('SELECT COUNT(*) FROM plans'),
    )!;
  }

  // get plans by date (day, week, month, year)
  Future<List<Plan>> getPlansByDate(String date) async {
    final db = await _database;
    final res = await db.query(
      'plans',
      where: 'date = ?',
      whereArgs: [date],
    );
    return res.isNotEmpty
        ? res.map((e) => Plan.fromMap(e)).toList()
        : <Plan>[];
  }


  Future close() async {
    final db = await _database;
    db.close();
  }

  
}
