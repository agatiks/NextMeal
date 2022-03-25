import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:next_meal/database/dishes_database.dart';
import 'package:next_meal/models/dish.dart';

class DishesDao {
  final dbProvider = DatabaseProvider.dbProvider;

  Future<int> addDish(Dish dish) async {
    final db = await dbProvider.database;
    var result = db.insert(dishesTABLE, dish.toDatabaseJson());
    return result;
  }

  Future<List<Dish>> getDishes({List<String>? columns, String? query}) async {
    if (kDebugMode) {
      print(" Helo");
    }
    final db = await dbProvider.database;
      var result = await db.query(dishesTABLE, columns: columns);
      List<Dish> dishes = result.isNotEmpty
          ? result.map((item) => Dish.fromDatabaseJson(item)).toList()
          : [];
      return dishes;
  }

  Future<Map<String, List<Dish>>> getCategorizedDishes() async {
    final db = await dbProvider.database;
    var rawCategories = await db.rawQuery('SELECT category FROM Dishes GROUP BY category');
    List<String> categories = rawCategories.isNotEmpty?
        rawCategories.map((e) => e['category'].toString()).toList():
        [];
    print("****************$categories");
    Map<String, List<Dish>> res = {};
    for (String category in categories) {
      var rawCategoryDishes = await db.query(dishesTABLE,
      columns: ['id', 'category', 'name', 'url'],
      where: 'category = ?',
      whereArgs: [category]);
      List<Dish> categoryDishes = rawCategoryDishes.isNotEmpty
          ? rawCategoryDishes.map((item) => Dish.fromDatabaseJson(item)).toList()
          : [];
      res[category] = categoryDishes;
    }

    /*print(result);
    List<Entry> dishes = result.isNotEmpty?
        result.map((category) {
          var rawCategoryDishes = await db.querySelector('category = $category');
          List<Dish> categoryDishes = rawCategoryDishes.isNotEmpty
              ? rawCategoryDishes.map((item) => Dish.fromDatabaseJson(item)).toList()
              : [];
          return Entry(KeyCode.S = category, categoryDishes)
        }).
        : {};
    return dishes;*/
    return res;
  }

  Future<int> updateDish(Dish dish) async {
    final db = await dbProvider.database;

    var result = await db.update(dishesTABLE, dish.toDatabaseJson(),
        where: "id = ?", whereArgs: [dish.id]);

    return result;
  }

  Future<int> deleteDish(int id) async {
    final db = await dbProvider.database;
    var result = await db.delete(dishesTABLE, where: 'id = ?', whereArgs: [id]);
    return result;
  }

  //We are not going to use this in the demo
  Future clearDishesDB() async {
    final db = await dbProvider.database;
    var result = await db.delete(
      dishesTABLE,
    );
    return result;
  }
}