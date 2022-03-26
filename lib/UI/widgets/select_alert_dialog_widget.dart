import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:next_meal/UI/widgets/loading_data_widget.dart';
import 'package:next_meal/blocs/dishes_bloc.dart';
import 'package:provider/provider.dart';

import 'category_item_widget.dart';

class SelectAlertDialogWidget extends StatelessWidget{
  const SelectAlertDialogWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<DishesBloc>(
        builder: (context, _dishesBloc, child) =>
        AlertDialog(
          title: const Text('Select category'),
          content: SizedBox(
            height: 300.0,
            width: 300.0,
            child: FutureBuilder(
                future: _dishesBloc.getCategories(),
                builder: (context, AsyncSnapshot<List<String>> snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      scrollDirection: Axis.vertical,
                      itemCount: snapshot.data?.length ?? 1,
                      itemBuilder: (context, itemPosition) {
                        return CategoryItemWidget(snapshot.data![itemPosition]);
                      },
                    );
                  }
                  return const LoadingDataWidget();
                }
            ),
          ),
        ),
    );
  }

}

