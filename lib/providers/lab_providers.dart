import 'package:test_ease/api/labs/labs.dart';
import 'package:test_ease/models/lab/labs.dart';
import 'package:test_ease/models/patients/order.dart';
import 'package:test_ease/providers/base_view_model.dart';

class LabProvider extends BaseViewModel {
  final LabApi _labApi = LabApi();
  Lab? _lab;
  Lab? get lab => _lab;

  List<Order> _orders = [];
  List<Order> get orders => _orders;

  Future<void> fetchCurrentLab() async {
    await runWithLoader(() async {
      _lab = await _labApi.getCurrentLab();
    });
  }

  Future<void> loginLab(String email, String psw) async {
    await runWithLoader(() async {
      _lab = await _labApi.loginLab(email, psw);
    });
  }

  Future<void> addTestToLab(String labId, String testId, int price) async {
    await runWithLoader(() async {
      await _labApi.addTestToLab(labId, testId, price);
    });
  }

  Future<void> updateLabProfile(Lab lab) async {
    await runWithLoader(() async {
      await _labApi.updateLabProfile(lab);
    });
  }

  Future<void> getLabOrders() async {
    await runWithLoader(() async {
      _orders = await _labApi.getOrders();
    });
  }
}
