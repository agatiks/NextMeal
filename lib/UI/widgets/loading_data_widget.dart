import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:next_meal/blocs/dishes_bloc.dart';
import 'package:provider/provider.dart';

class LoadingDataWidget extends StatelessWidget {
  const LoadingDataWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DishesBloc>(
      builder: (context, _dishesBloc, child) {
        _dishesBloc.getDishes();
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
      },
    );
  }

}