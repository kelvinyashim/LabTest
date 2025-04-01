import 'package:flutter/material.dart';
import 'package:test_ease/api/user.dart';
import 'package:test_ease/models/patient.dart';

class PatientsProvider extends ChangeNotifier {
  final UserApi _userApi = UserApi();

  final List<Patient> _patients = [];
  bool _isLoading = false;
  List<Patient> get patients => _patients;
  bool get isLoading => _isLoading;
  Patient? _currentpatient;
  Patient? get currentpatient => _currentpatient;

  Future<void> fetchCurrentPatient() async {
    _isLoading = true;
     _currentpatient = null; 
    notifyListeners();
    try {
      final patient = await _userApi.getCurrentPatient();
      _currentpatient = patient;
    } catch (e) {
      _currentpatient = null;

      throw Exception(e.toString());
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> createPatient(Patient patient) async {
    try {
      final newPatient = await _userApi.createUser(patient);
      _patients.add(newPatient);
      notifyListeners();
    } catch (error) {
      throw Exception(error.toString());
    }
  }

  Future<void> updatePatient(Patient patient) async {
    try {
      final updatedPatient = await _userApi.updatePatient(patient);
      final index = _patients.indexWhere((element) => element.id == patient.id);
      if (index != -1) {
        _patients[index] = updatedPatient;
        notifyListeners();
      }
      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<void> loginPatient(String email, String password) async {
    try {
      await _userApi.loginUser(email, password);
      notifyListeners();
    } catch (e) {
      throw Exception(e.toString());
    }
  }

  Future<Patient> getCurrentPatient() async {
    _isLoading = true;
    try {
      final patient = await _userApi.getCurrentPatient();
      return patient;
    } catch (e) {
      _isLoading = false;
      throw Exception(e.toString());
    }
  }

  //Admin
  Future<void> getPatients() async {
    _isLoading = true;
    notifyListeners();
    try {
      final patients = await _userApi.getPatients();
      _patients.clear();
      _patients.addAll(patients);
    } catch (e) {
      throw Exception(e.toString());
    }
    _isLoading = false;
    notifyListeners();
  }
}
