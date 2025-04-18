import 'package:flutter/material.dart';

class ScheduleProvider extends ChangeNotifier {
  String? _selectedAddress;
  String? _selectedDate;
  String? _selectedTime;

  String ? get selectedAddress => _selectedAddress;
  String ? get selectedDate => _selectedDate;
  String ? get selectedTime => _selectedTime;

  void selectAddress(String value){
      print("Address selected: $value");
    _selectedAddress = value;
    notifyListeners();
  }

  void selectDate(String value){
    _selectedDate = value;
    notifyListeners();
    }
    void selectTime(String value){
      _selectedTime = value;
      notifyListeners();
      }
}
