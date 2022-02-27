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
    var result = await db.query(dishesTABLE, columns: columns);;
    /*if (query != null) {
      if (query.isNotEmpty) {
        result = await db.query(dishesTABLE,
            columns: columns,
            where: 'name LIKE ?',
            whereArgs: ["%$query%"]);
      }
    } else {
      result = await db.query(dishesTABLE, columns: columns);
    //}*/

    List<Dish> dishes = result.isNotEmpty
        ? result.map((item) => Dish.fromDatabaseJson(item)).toList()
        : [];
    return dishes;
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