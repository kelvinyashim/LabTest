import 'package:test_ease/api/labs/labs.dart';
import 'package:test_ease/api/phleb/phleb_api.dart';
import 'package:test_ease/models/phleb/phleb.dart';
import 'package:test_ease/models/phleb/phleb_orders.dart';
import 'package:test_ease/providers/base_view_model.dart';

class PhlebProvider extends BaseViewModel {
  LabApi labApi = LabApi();
  PhlebApi phlebApi = PhlebApi();

  Phleb? _phleb;
  Phleb? get phleb => _phleb;

  List<Phleb> _phlebs = [];
  List<Phleb> get phlebs => _phlebs;

   List<PhlebOrders> _orders = [];
  List<PhlebOrders> get orders => _orders;
  //LABS
  Future<void> addPhleb(Phleb phleb) async {
    await runWithLoader(() async {
      final newPhleb = await labApi.addPhleb(phleb);
      _phlebs.add(newPhleb);
    });
  }

  Future<void> getPhlebs() async {
    await runWithLoader(() async {
      final allPhlebs = await labApi.getAllPhlebs();
      _phlebs = allPhlebs;
    });
  }

  //PHLEBOTOMIST
  Future<void> loginPhleb(String email, String psw) async {
    await runWithLoader(() async {
      await phlebApi.loginPhleb(email, psw);
    });
  }

  Future<void> getOrders() async {
    await runWithLoader(() async {
    _orders =  await phlebApi.getOrdersPhleb();
    });
  }

   Future<void> acceptOrder(String id) async {
    await runWithLoader(() async {
       await phlebApi.acceptOrder(id);
    });
  }

  Future<void> markComplete(String id) async {
    await runWithLoader(() async {
       await phlebApi.markComplete(id);
    });
  }


List<PhlebOrders> getOngoingOrders() {
  return _orders.where((order) => order.status != 'Completed').toList();
}

List<PhlebOrders> getCompletedOrders() {
  return _orders.where((order) => order.status == 'Completed').toList();
}


}
