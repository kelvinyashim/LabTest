import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ScheduleProvider extends ChangeNotifier {
  String? _selectedAddress;
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;

  String? get selectedAddress => _selectedAddress;
  DateTime? get selectedDate => _selectedDate;
  TimeOfDay? get selectedTime => _selectedTime;

  void selectAddress(String value) {
    _selectedAddress = value;
    notifyListeners();
  }

  void selectDate(DateTime value) {
    _selectedDate = value;
    notifyListeners();
  }

  void selectTime(TimeOfDay value) {
    _selectedTime = value;
    notifyListeners();
  }

  String formatTimeOfDay(TimeOfDay timeOfDay) {
    final hour = timeOfDay.hour;
    final minute = timeOfDay.minute;
    return '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
  }

   String get formattedDate {
    if (_selectedDate == null) return 'Not selected';
    return DateFormat('yyyy-MM-dd').format(_selectedDate!); // or any other format you want
  }

   String get formattedTime {
    if (_selectedTime == null) return 'Not selected';
    return formatTimeOfDay(_selectedTime!);
  }
}
