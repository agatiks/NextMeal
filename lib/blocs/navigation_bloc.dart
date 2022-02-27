import 'dart:async';

import 'package:next_meal/blocs/events/selected_item_event.dart';

class NavigationBloc{
  int _selectedItem = 0;

  // init and get StreamController
  final _selectedItemStreamController = StreamController<int>();
  StreamSink<int> get selectedItem_sink => _selectedItemStreamController.sink;

  // expose data from stream
  Stream<int> get stream_selectedItem => _selectedItemStreamController.stream;

  final _selectedItemEventController = StreamController<SelectedItemEvent>();
  // expose sink for input events
  Sink <SelectedItemEvent> get selectedItem_event_sink => _selectedItemEventController.sink;

  NavigationBloc() {  _selectedItemEventController.stream.listen(_selectItem);  }


  _selectItem(SelectedItemEvent event) => selectedItem_sink.add(_selectedItem = event.item);

  dispose(){
    _selectedItemStreamController.close();
    _selectedItemEventController.close();
  }
}