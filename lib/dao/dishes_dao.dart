import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:next_meal/database/dishes_database.dart';
import 'package:next_meal/models/dish.dart';

class DishesDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> addDish(Dish dish) async {
    final db = await dbProvider.database;
    var result = db.insert(dishesTable, dish.toDatabaseJson());
    return result;
  }

  Future<List<Dish>> getDishes({List<String>? columns, String? query}) async {
    if (kDebugMode) {
      print(" Helo");
    }
    final db = await dbProvider.database;
      var result = await db.query(dishesTable, columns: columns);
      List<Dish> dishes = result.isNotEmpty
          ? result.map((item) => Dish.fromDatabaseJson(item)).toList()
          : [];
      return dishes;
  }

  Future<List<String>> getCategories() async {
    final db = await dbProvider.database;
    var rawCategories = await db.rawQuery('SELECT category FROM Dishes GROUP BY category');
    List<String> categories = rawCategories.isNotEmpty?
    rawCategories.map((e) => e['category'].toString()).toList():
    [];
    return categories;
  }

  Future<Map<String, List<Dish>>> getCategorizedDishes() async {
    final db = await dbProvider.database;
    List<String> categories = await getCategories();
    Map<String, List<Dish>> res = {};
    for (String category in categories) {
      var rawCategoryDishes = await db.query(dishesTable,
      columns: ['id', 'category', 'name', 'url'],
      where: 'category = ?',
      whereArgs: [category]);
      List<Dish> categoryDishes = rawCategoryDishes.isNotEmpty
          ? rawCategoryDishes.map((item) => Dish.fromDatabaseJson(item)).toList()
          : [];
      res[category] = categoryDishes;
    }
    return res;
  }

  Future<int> updateDish(Dish dish) async {
    final db = await dbProvider.database;

    var result = await db.update(dishesTable, dish.toDatabaseJson(),
        where: "id = ?", whereArgs: [dish.id]);

    return result;
  }

  Future<int> deleteDish(int id) async {
    final db = await dbProvider.database;
    var result = await db.delete(dishesTable, where: 'id = ?', whereArgs: [id]);
    return result;
  }

  //We are not going to use this in the demo
  Future clearDishesDB() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      dishesTable,
    );
    return result;
  }
}