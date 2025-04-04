import 'package:flutter/material.dart';
import 'package:test_ease/api/user.dart';
import 'package:test_ease/models/patient.dart';

class PatientsProvider extends ChangeNotifier {
  final UserApi _userApi = UserApi();

  bool _isLoading = false;
  Patient? _currentpatient;
  
  bool get isLoading => _isLoading;
  Patient? get currentpatient => _currentpatient;

  // Fetch the current patient data from the API
  Future<void> fetchCurrentPatient() async {
    _isLoading = true;
    try {
      final patient = await getCurrentPatient();
      _currentpatient = patient;
    } catch (e) {
      _currentpatient = null;
      throw Exception(e.toString());
    } finally {
      _isLoading = false; // ✅ Set loading to false when fetching is done
      notifyListeners(); 
    }
  }

  Future<Patient> getCurrentPatient() async {
    try {
      final patient = await _userApi.getCurrentPatient();
      return patient;
    } catch (e) {
      throw Exception('Failed to load patient: $e');
    }
  }

  // Create a new patient
  Future<void> createPatient(Patient patient) async {
    _isLoading = true;
    notifyListeners(); 

    try {
      final newPatient = await _userApi.createUser(patient);
      _currentpatient = newPatient; 
      notifyListeners(); 
    } catch (e) {
      throw Exception('Failed to create patient: $e');
    } finally {
      _isLoading = false; 
      notifyListeners(); 
    }
  }

  // Update patient information
  Future<void> updatePatient(Patient patient) async {
    try {
      final updatedPatient = await _userApi.updatePatient(patient);
      _currentpatient = updatedPatient; 
      notifyListeners();
    } catch (e) {
      throw Exception('Failed to update patient: $e');
    }
  }

  Future<void> loginPatient(String email, String password) async {
    try {
      await _userApi.loginUser(email, password);
      notifyListeners();
    } catch (e) {
      throw Exception('Check email or password');
    }
  }
}
