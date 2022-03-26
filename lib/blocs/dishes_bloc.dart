import 'dart:async';

import 'package:next_meal/models/dish.dart';
import 'package:next_meal/repository/dishes_repository.dart';

class DishesBloc {
  final _dishesRepository = DishesRepository();
  final _dishesController = StreamController<Map<String, List<Dish>>>.broadcast();

  get dishes => _dishesController.stream;

  DishesBloc() {
    getDishes();
  }

  getDishes({String? query}) async {
    _dishesController.sink.add(await _dishesRepository.getCategorizedDishes());
  }

  Future<List<String>> getCategories() async{
    print('******${_dishesRepository.getCategories().runtimeType}');
    return _dishesRepository.getCategories();
  }

  addDish(Dish dish) async {
    await _dishesRepository.addDish(dish);
    getDishes();
  }

  updateDish(Dish dish) async {
    await _dishesRepository.updateDish(dish);
    getDishes();
  }

  deleteDishById(int id) async {
    _dishesRepository.deleteDishById(id);
    getDishes();
  }



  dispose() {
    _dishesController.close();
  }
}