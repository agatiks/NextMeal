import 'package:next_meal/dao/dishes_dao.dart';
import 'package:next_meal/models/dish.dart';

class DishesRepository {
  final dishesDao = DishesDao();

  Future getAllDishes({String? query}) => dishesDao.getDishes(query: query);

  Future getCategorizedDishes() => dishesDao.getCategorizedDishes();

  Future<List<String>> getCategories() => dishesDao.getCategories();

  Future addDish(Dish dish) => dishesDao.addDish(dish);

  Future updateDish(Dish dish) => dishesDao.updateDish(dish);

  Future deleteDishById(int id) => dishesDao.deleteDish(id);

  Future deleteAllDishes() => dishesDao.clearDishesDB();
}