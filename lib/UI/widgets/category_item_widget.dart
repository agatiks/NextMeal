import 'package:flutter/material.dart';
import 'package:next_meal/blocs/selected_categories_bloc.dart';
import 'package:provider/provider.dart';

class CategoryItemWidget extends StatelessWidget{
  final String _category;
  const CategoryItemWidget(this._category, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          side: BorderSide(color: Colors.grey.shade200, width: 0.5),
          borderRadius: BorderRadius.circular(5),
        ),
        color: Colors.purple.shade200,
        child: Consumer<SelectedCategoriesBloc>(
          builder: (context, _bloc, child)
          => StreamBuilder(
            stream: _bloc.selectedItemStream,
            builder: (context, snapshot) {
              return InkWell(
                  onTap: () {
                    _bloc.selectedItemSink.add(_category);
                    Navigator.pop(context);
                  },
                  child: ListTile(
                    contentPadding:
                    const EdgeInsets.symmetric(vertical: 6, horizontal: 16),
                    title: Text(
                      _category,
                      style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600, ),
                    ),
                  )
              );
            }
          ),
        ));
  }
}