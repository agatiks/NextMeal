import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:next_meal/UI/widgets/select_alert_dialog_widget.dart';
import 'package:next_meal/blocs/dishes_bloc.dart';
import 'package:next_meal/blocs/selected_categories_bloc.dart';
import 'package:next_meal/models/dish.dart';
import 'package:provider/provider.dart';

class GeneratePage extends StatefulWidget {
  GeneratePage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => GeneratePageState();
}

class GeneratePageState extends State<StatefulWidget> {
  late DishesBloc _dishesBloc;
  late SelectedCategoriesBloc _selectedCategoriesBloc;
  List<String> _toGenerate = [];

  @override
  Widget build(BuildContext context) {
    _dishesBloc = Provider.of<DishesBloc>(context, listen: false);
    _selectedCategoriesBloc =
        Provider.of<SelectedCategoriesBloc>(context, listen: false);
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 16,),
          FloatingActionButton.extended(
              onPressed: () => showSelectDialog(context),
              label: const Text('add category')),
          const SizedBox(height: 16,),
          generatingList(),
          const SizedBox(height: 16,),
          FloatingActionButton.extended(
              onPressed: () => _toGenerate.clear(),
              label: const Text('restart')),
          const SizedBox(height: 16,),
          FloatingActionButton.extended(
            backgroundColor: Colors.purple.shade200,
              onPressed: () => _toGenerate.clear(),
              label: const Icon(Icons.all_inclusive)),
          const SizedBox(height: 16,),
          generatedList(),
        ],
      ),
    );
  }

  Widget generatingList() {
    return FutureBuilder(
      future: _dishesBloc.getCategories(),
      //TODO: Futures are bad and not for bloc
      builder: (BuildContext context, AsyncSnapshot<List<String>> snapshot) =>
          StreamBuilder(
        stream: _selectedCategoriesBloc.selectedItemStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _toGenerate.add(snapshot.data!.toString());
          }
          return Text(_toGenerate.join(' + '), style: TextStyle(fontSize: 30), textAlign: TextAlign.center,);
        },
      ),
    );
  }

  Widget generatedList() {
    return Text('hello');
  }

  String? showSelectDialog(BuildContext context) {
    showDialog(
        context: context, builder: (_) => const SelectAlertDialogWidget());
  }
}
