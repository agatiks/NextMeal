import 'dart:ui';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:next_meal/blocs/dishes_bloc.dart';
import 'package:next_meal/models/dish.dart';
import 'package:url_launcher/url_launcher.dart';

class DishesPage extends StatelessWidget {
  DishesPage({Key? key}) : super(key: key);

  final DishesBloc dishesBloc = DishesBloc();
  final DismissDirection _dismissDirection = DismissDirection.horizontal;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: dishesWidget(),
    );
  }

  Widget dishesWidget() {
    return StreamBuilder(
      stream: dishesBloc.dishes,
      builder: (BuildContext context,
          AsyncSnapshot<Map<String, List<Dish>>> snapshot) {
        return Column(
          children: [
            FloatingActionButton.extended(
                label: const Text("add"),
                onPressed: () => addDishSheet(context)),
            const SizedBox(height: 8.0),
            dishListWidget(snapshot),
          ],
        );
      },
    );
  }

  Widget dishListWidget(AsyncSnapshot<Map<String, List<Dish>>> snapshot) {
    if (snapshot.hasData) {
      return (snapshot.data!.isNotEmpty)
          ? Flexible(
              child: ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: snapshot.data?.length,
                itemBuilder: (context, itemPosition) {
                  Map<String, List<Dish>> content = snapshot.data!;
                  String curKey = content.keys.toList()[itemPosition];
                  return categoryListWidget(curKey, content[curKey] ?? []);
                },
              ),
            )
          : const Center(
              child: Text(
                "Start adding dish...",
                style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500),
              ),
            );
    } else {
      return Center(
        child: loadingData(),
      );
    }
  }

  Widget categoryListWidget(String category, List<Dish> categoryList) {
    return Column(
      children: [
        const SizedBox(
          height: 8.0,
        ),
        Text(
          category,
          style: const TextStyle(
              fontSize: 28,
              fontStyle: FontStyle.italic,
              fontWeight: FontWeight.w300),
        ),
        const SizedBox(
          height: 8.0,
        ),
        ListView.builder(
          shrinkWrap: true,
          scrollDirection: Axis.vertical,
          itemCount: categoryList.length,
          itemBuilder: (context, itemPosition) {
            return dishItem(context, categoryList[itemPosition]);
          },
        ),
      ],
    );
  }

  Widget dishItem(BuildContext context, Dish dish) {
    final Widget dismissibleCard = Dismissible(
      background: Container(
        decoration: BoxDecoration(
          color: Colors.purple.shade100,
          borderRadius: BorderRadius.circular(5),
        ),
        child: const Padding(
          padding: EdgeInsets.only(left: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              //TODO make delayed delete
              "Deleting",
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      onDismissed: (direction) {
        dishesBloc.deleteDishById(dish.id!);
      },
      direction: _dismissDirection,
      key: ObjectKey(dish),
      child: Card(
          shape: RoundedRectangleBorder(
            side: BorderSide(color: Colors.grey.shade200, width: 0.5),
            borderRadius: BorderRadius.circular(5),
          ),
          color: Colors.white,
          child: InkWell(
            onTap: () => updateDishSheet(context, dish),
            child: ListTile(
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                title: Text(
                  dish.name,
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w600),
                ),
                subtitle: GestureDetector(
                  child: Text(dish.url ?? "None",
                      style: const TextStyle(
                          decoration: TextDecoration.underline,
                          color: Colors.blue)),
                  onTap: () async {
                    if (await launch(dish.url ?? "None"))
                      throw 'Could not launch $dish.description';
                  },
                )),
          )),
    );
    return dismissibleCard;
  }

  void addDishSheet(BuildContext context) {
    //TODO a lot of copy-paste
    final _dishNameFormController = TextEditingController();
    final _dishUrlFormController = TextEditingController();
    final _dishCategoryFormController = TextEditingController();
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Colors.white,
        context: context,
        isScrollControlled: true,
        builder: (context) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(
                    height: 16.0,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      'New dish',
                      style:
                          TextStyle(fontSize: 21, fontWeight: FontWeight.w400),
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    decoration: const InputDecoration(hintText: 'Name'),
                    autofocus: true,
                    controller: _dishNameFormController,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    decoration: const InputDecoration(hintText: 'URL'),
                    autofocus: true,
                    controller: _dishUrlFormController,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    decoration: const InputDecoration(hintText: 'Category'),
                    autofocus: true,
                    controller: _dishCategoryFormController,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Center(
                        child: FloatingActionButton.extended(
                            onPressed: () {
                              final newDish = Dish(
                                name: _dishNameFormController.value.text,
                                url: _dishUrlFormController.value.text,
                                category:
                                    _dishCategoryFormController.value.text,
                              );
                              if (newDish.name.isNotEmpty) {
                                dishesBloc.addDish(newDish);

                                //dismisses the bottomsheet
                                Navigator.pop(context);
                              }
                            },
                            label: const Text('add')),
                      )),
                  const SizedBox(height: 10),
                ],
              ),
            ));
  }

  Widget loadingData() {
    dishesBloc.getDishes();
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          CircularProgressIndicator(),
          Text("Loading...",
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w500))
        ],
      ),
    );
  }

  dispose() {
    dishesBloc.dispose();
  }

  void updateDishSheet(BuildContext context, Dish dish) {
    final _dishNameFormController = TextEditingController();
    final _dishUrlFormController = TextEditingController();
    final _dishCategoryFormController = TextEditingController();
    showModalBottomSheet(
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(25.0))),
        backgroundColor: Colors.white,
        isScrollControlled: true,
        builder: (context) => Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(
                    height: 16.0,
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      'Update dish',
                      style:
                          TextStyle(fontSize: 21, fontWeight: FontWeight.w400),
                    ),
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    //initialValue: dish.name,
                    autofocus: true,
                    controller: _dishNameFormController..text = dish.name,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    decoration: const InputDecoration(hintText: 'URL'),
                    autofocus: true,
                    controller: _dishUrlFormController..text = dish.url ?? '',
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  TextField(
                    autofocus: true,
                    controller: _dishCategoryFormController
                      ..text = dish.category,
                  ),
                  const SizedBox(
                    height: 8.0,
                  ),
                  Padding(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: Center(
                        child: FloatingActionButton.extended(
                            onPressed: () {
                              final newDish = Dish(
                                name: _dishNameFormController.value.text,
                                url: _dishUrlFormController.value.text,
                                category:
                                    _dishCategoryFormController.value.text,
                              );
                              if (newDish.name.isNotEmpty &&
                                  newDish.category.isNotEmpty) {
                                dishesBloc.updateDish(newDish);

                                //dismisses the bottomsheet
                                Navigator.pop(context);
                              }
                            },
                            label: const Text('update')),
                      )),
                  const SizedBox(height: 10),
                ],
              ),
            ),
        context: context);
  }
}
