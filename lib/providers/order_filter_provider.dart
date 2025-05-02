// order_filter_provider.dart
import 'package:flutter/material.dart';

class OrderFilterProvider extends ChangeNotifier {
  bool _showOngoing = true;

  bool get showOngoing => _showOngoing;

  void toggle(bool value) {
    _showOngoing = value;
    notifyListeners();
  }
}
