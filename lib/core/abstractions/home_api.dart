abstract class HomeApi {
  int get counter;
  void setCounter(int value);
  Function(int) onCounterChanged = (value) {};
  void setOnCounterChanged(Function(int) callback) => onCounterChanged = callback;
}