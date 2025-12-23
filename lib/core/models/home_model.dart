import 'package:camaroo/core/abstractions/home_api.dart';

class HomeModel implements HomeApi{

  int _counter = 0;
  @override
  int get counter => _counter;
  @override
  void setCounter(int value) {
    _counter = value;
    onCounterChanged(value);
  }
  @override
  Function(int) onCounterChanged = (value) {};
  @override
  void setOnCounterChanged(Function(int) callback) => onCounterChanged = callback;
}