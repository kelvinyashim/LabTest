import 'package:flutter/material.dart';

abstract class BaseViewModel with ChangeNotifier {
  bool _isLoading = false;
  String? _error;

  bool get isLoading => _isLoading;
  String? get error => _error;

  @protected
  Future<T> runWithLoader<T>(Future<T> Function() task) async {
    _isLoading = true;
    _error = null;
    notifyListeners();
    try {
      return await task();
    } catch (e) {
      _error = e.toString();
      rethrow;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}
