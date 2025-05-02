import 'package:hive/hive.dart';
import 'package:test_ease/models/patients/cart.dart';
import 'package:test_ease/providers/base_view_model.dart';

class CartBoxProvider extends BaseViewModel {
  Box<CartItem>? _cartBox;
  bool _isInitialized = false;

  bool get isInitialized => _isInitialized;

  Box<CartItem> get cartbox {
    if (_cartBox == null) {
      throw Exception("CartBox is not initialized");
    }
    return _cartBox!;
  }

  Future<void> initCart() async {
    await runWithLoader(() async {
      _cartBox = await Hive.openBox<CartItem>('cart');
      _isInitialized = true;
      notifyListeners();
    });
  }
}
