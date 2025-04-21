import 'package:test_ease/api/patient.dart';
import 'package:test_ease/models/labs.dart';
import 'package:test_ease/models/order.dart';
import 'package:test_ease/models/patient.dart';
import 'package:test_ease/providers/base_view_model.dart';

class PatientsProvider extends BaseViewModel {
  final UserApi _userApi = UserApi();

  Patient? _currentpatient;

  Patient? get currentpatient => _currentpatient;

  Lab? _currentlab;
  Lab? get currentlab => _currentlab;

  List<String> _adrresses = [];
  List<String> get addresses => _adrresses;

  Order? _order;
  Order? get order => _order;

  List<Order> _orders = [];
  List<Order> get orders => _orders;

  Future<void> fetchCurrentPatient() async {
    await runWithLoader(() async {
      _currentpatient = await _userApi.getCurrentPatient();
    });
  }

  Future<void> createPatient(Patient patient) async {
    await runWithLoader(() async {
      await _userApi.createUser(patient);
    });
  }

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

  Future<void> getPatientAddress() async {
    await runWithLoader(() async {
      final fetched = await _userApi.getPatientAddress();
      _adrresses = fetched;
    });
  }

  Future<void> addAddress(String newAddress) async {
    await runWithLoader(() async {
      await _userApi.addAddress(newAddress);
      _adrresses.add(newAddress);
    });
  }

  Future<void> createOrder(Order order) async {
    await runWithLoader(() async {
      _order = await _userApi.createOrder(order);
    });
  }

  Future<void> getOrders() async {
    await runWithLoader(() async {
      _orders = await _userApi.getOrders();
    });
  }
}
