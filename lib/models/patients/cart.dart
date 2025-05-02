import 'package:hive/hive.dart';
import 'package:test_ease/models/patients/labs_test.dart';
part 'cart.g.dart';
@HiveType(typeId: 0)
class CartItem {
  @HiveField(0)
  final LabsTest labsTest;
  

  const CartItem({
    required this.labsTest,
  });



}
