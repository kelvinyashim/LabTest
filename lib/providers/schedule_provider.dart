import 'package:flutter/material.dart';

class ScheduleProvider extends ChangeNotifier {
  String? _selectedAddress;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  String ? get selectedAddress => _selectedAddress;
  DateTime ? get selectedDate => _selectedDate;
  TimeOfDay ? get selectedTime => _selectedTime;

  void selectAddress(String value){
    _selectedAddress = value;
    notifyListeners();
  }

  void selectDate(DateTime value){
    _selectedDate = value;
    notifyListeners();
    }
    void selectTime(TimeOfDay value){
      _selectedTime = value;
      notifyListeners();
      }
}
