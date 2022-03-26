import 'package:flutter/material.dart';
import 'package:next_meal/blocs/dishes_bloc.dart';
import 'package:next_meal/blocs/selected_categories_bloc.dart';
import 'package:provider/provider.dart';

import 'UI/home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [Provider<DishesBloc>(create: (_) => DishesBloc()),
          Provider<SelectedCategoriesBloc>(create: (_) => SelectedCategoriesBloc())],
      child: MaterialApp(
        title: 'NextMeal',
        theme: ThemeData(
          primarySwatch: Colors.purple,
        ),
        home: HomePage(),
      ),
    );
  }
}

