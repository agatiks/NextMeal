import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

const dishesTable = 'Dishes';
const categoriesTable = 'Categories';
class DatabaseProvider {
  static final DatabaseProvider dbProvider = DatabaseProvider();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await createDatabase();
    return _database!;
  }

  createDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, "ReactiveDishes.db");
    var database = await openDatabase(path,
        version: 1, onCreate: initDB, onUpgrade: onUpgrade);
    return database;
  }

  //This is optional, and only used for changing DB schema migrations
  void onUpgrade(Database database, int oldVersion, int newVersion) {
    if (newVersion > oldVersion) {}
  }

  void initDB(Database database, int version) async {
    await database.execute("CREATE TABLE $dishesTable ("
        "id INTEGER PRIMARY KEY, "
        "name TEXT, "
        "url TEXT, "
        "category TEXT"
        ")");
    await database.execute("CREATE TABLE $categoriesTable ("
        "id INTEGER PRIMARY KEY, "
        "category TEXT, "
        "color TEXT, "
        ")");
  }
}