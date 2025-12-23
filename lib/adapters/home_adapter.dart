import 'package:camaroo/core/abstractions/home_api.dart';
import 'package:flutter/material.dart';

class HomeAdapter {
  HomeAdapter(HomeApi homeApi) {
    counterNotifier = ValueNotifier(homeApi.counter);
    homeApi.onCounterChanged = (value) => counterNotifier.value = value;
  }

  late final ValueNotifier<int> counterNotifier;
}
