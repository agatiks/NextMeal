import 'dart:async';

import 'events/selected_category_item_event.dart';

class SelectedCategoriesBloc{
  String _selectedItem = '';

  final _selectedItemStreamController = StreamController<String>.broadcast();
  final _selectedItemEventController = StreamController<SelectedCategoryItemEvent>.broadcast();

  get selectedItemStream => _selectedItemStreamController.stream;
  get selectedItemSink => _selectedItemStreamController.sink;
  get selectedItemEventSink=> _selectedItemEventController.sink;

  SelectedCategoriesBloc() {  _selectedItemEventController.stream.listen(_selectItem);  }
  _selectItem(SelectedCategoryItemEvent event) => selectedItemStream.add(_selectedItem = event.item);

  dispose(){
    _selectedItemStreamController.close();
    _selectedItemEventController.close();
  }
}