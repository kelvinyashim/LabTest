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

  /// 🔹 Remove by index/key
  Future<void> removeItemAt(int index) async {
    await cartbox.deleteAt(index);
    notifyListeners();
  }

  /// 🔹 Remove by labsTest ID (if stored uniquely)
  Future<void> removeItemByTestId(String testId) async {
    final keyToRemove = cartbox.keys.firstWhere(
      (key) => cartbox.get(key)?.labsTest.id == testId,
      orElse: () => null,
    );
    if (keyToRemove != null) {
      await cartbox.delete(keyToRemove);
      notifyListeners();
    }
  }

  /// 🔹 Clear the entire cart
  Future<void> clearCart() async {
    await cartbox.clear();
    notifyListeners();
  }
}
