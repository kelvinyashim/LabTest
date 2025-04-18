import 'package:flutter/material.dart';

class StepProvider extends ChangeNotifier {
  int _currentstep = 0;
  int get currentstep => _currentstep;

  void setNewStep(int newStep) {
    _currentstep = newStep;
    notifyListeners();
  }
}
