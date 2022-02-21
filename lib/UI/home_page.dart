import 'package:flutter/material.dart';
import 'package:next_meal/UI/screens/dishes_page.dart';
import 'package:next_meal/UI/screens/generate_page.dart';
import 'package:next_meal/UI/screens/personal_page.dart';
import 'package:next_meal/UI/selected_item_event.dart';
import 'package:next_meal/blocs/navigation_bloc.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class HomePage extends StatelessWidget{
  final _navigationBloc = NavigationBloc();

  HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return StreamBuilder(
        stream: _navigationBloc.stream_selectedItem,
        initialData: 0,
        builder: (context, snapshot) {
          return Scaffold(
            appBar: AppBar(
              title: const Text("NextMeal"),
            ),
            bottomSheet:
            /*return Text(snapshot.data.toString());*/
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: SalomonBottomBar(
                currentIndex: int.parse(snapshot.data.toString()),
                onTap: (i) =>
                    _navigationBloc.selectedItem_event_sink.add(
                        SelectedItemEvent(i)),
                items: [

                  /// Dishes
                  SalomonBottomBarItem(
                    icon: const Icon(Icons.dinner_dining),
                    title: const Text("My Dishes"),
                    selectedColor: Colors.purple,
                  ),

                  /// Generate
                  SalomonBottomBarItem(
                    icon: const Icon(Icons.all_inclusive),
                    title: const Text("Generate"),
                    selectedColor: Colors.teal,
                  ),

                  ///Personal
                  SalomonBottomBarItem(
                    icon: const Icon(Icons.person),
                    title: const Text("Personal"),
                    selectedColor: Colors.amber,
                  ),
                ],
              ),
            ),
            body: getBody(snapshot),
          );
        }
    );
  }

  getBody(AsyncSnapshot<Object?> snapshot) {
    var currPage = int.parse(snapshot.data.toString());
    if ( currPage == 0) {
      return const DishesPage();
      //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const DishesPage()));
    } else if (currPage == 1) {
      //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const GeneratePage()));
      return const GeneratePage();
    } else{
      return const PersonalPage();
      //Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => const PersonalPage()));
    }
  }
}