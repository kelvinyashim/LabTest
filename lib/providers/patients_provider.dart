import 'package:test_ease/api/patient.dart';
import 'package:test_ease/models/labs.dart';
import 'package:test_ease/models/patient.dart';
import 'package:test_ease/providers/base_view_model.dart';

class PatientsProvider extends BaseViewModel {
  final UserApi _userApi = UserApi();

  Patient? _currentpatient;

  Patient? get currentpatient => _currentpatient;

  Lab ? _currentlab;
  Lab? get currentlab => _currentlab;



  Future<void> fetchCurrentPatient() async {
    await runWithLoader(() async {
      _currentpatient = await _userApi.getCurrentPatient();
    });
  }

  // Create a new patient
  Future<void> createPatient(Patient patient) async {
    await runWithLoader(() async {
      await _userApi.createUser(patient);
    });
  }

  // Update patient information
  Future<void> updatePatient(Patient patient) async {
    await runWithLoader(() async {
      await _userApi.updatePatient(patient);
    });
  }

  Future<void> loginPatient(String email, String password) async {
    await runWithLoader(() async {
      await _userApi.loginUser(email, password);
    });
  }

   Future<void> getLabInfo(String id) async {
    await runWithLoader(() async {
     _currentlab = await _userApi.getLabInfo(id);
    });
  }
}
