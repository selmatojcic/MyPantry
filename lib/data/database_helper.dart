import 'package:my_pantry/model/ingredient.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'fridge_ingredients.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE fridge_ingredients(
          id INTEGER PRIMARY KEY,
          name TEXT,
          image TEXT
      )
      ''');
  }

  Future<List<Result>> getIngredients() async {
    Database db = await instance.database;
    var fridgeIngredients = await db.query('fridge_ingredients', orderBy: 'name');
    List<Result> fridgeIngredientsList = fridgeIngredients.isNotEmpty
        ? fridgeIngredients.map((c) => Result.fromMap(c)).toList() : [];
    return fridgeIngredientsList;
  }

  Future<int> add(Result ingredient) async {
    Database db = await instance.database;
    return await db.insert('fridge_ingredients', ingredient.toMap());
  }
}