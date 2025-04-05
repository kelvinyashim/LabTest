import 'package:flutter/material.dart';
import 'package:test_ease/api/labs/labs.dart';
import 'package:test_ease/models/labs.dart';

class LabProvider extends ChangeNotifier {
  LabApi _labApi = LabApi();
  Lab? _lab;
  Lab? get lab => _lab;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> fetchCurrentLab() async {
    _isLoading = true;
    try {
      final lab = await getCurrentLab();
      _lab = lab;
    } catch (e) {
      _lab = null;
      throw Exception(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
    ;
  }

  Future<void> loginLab(String email, String psw) async {
    try {
      await _labApi.loginLab(email, psw);
      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Lab> getCurrentLab() async {
    try {
      final lab = await _labApi.getCurrentLab();
      return lab;
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> addTestToLab(String labId, String testId, int price) async {
    try {
      await _labApi.addTestToLab(labId, testId, price);
      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> updateLabProfile(Lab lab) async {
    try {
      await _labApi.updateLabProfile(lab);
      _lab = lab;
      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> getLabTests(String id) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _labApi.getLabTests(id);
    } catch (e) {
      throw Exception(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
