import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:test_ease/constants/color.dart';
import 'package:test_ease/main.dart';
import 'package:test_ease/providers/cart_box_provider.dart';
import 'package:test_ease/views/patient/order/schedule_screen.dart';
import 'package:test_ease/widgets/checkout_btn.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<CartBoxProvider>(context);
    final cartItems = cartProvider.cartbox.values.toList();
        int totalPrice = cartProvider.cartbox.values
            .map((e) => e.labsTest.price)
            .fold(0, (prev, curr) => prev + curr);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Cart',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: AppColors.greenBtn,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          if (cartItems.isEmpty)
            const Expanded(
              child: Center(
                child: Text("Your cart is empty."),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return Dismissible(
                    key: Key(item.labsTest.id!), // Ensure unique ID
                    direction: DismissDirection.endToStart,
                    background: Container(
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.only(bottomRight: Radius.circular(30),topRight: Radius.circular(30))

                      ),
                  
                      alignment: Alignment.centerRight,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: const Icon(Icons.delete, color: Colors.white),
                    ),
                    onDismissed: (direction) {
                      cartProvider.removeItemAt(index);
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          duration: Duration(milliseconds: 450),
                          backgroundColor: Colors.white,
                          content: Text("Item removed from cart", style: TextStyle(color: Colors.red),),
                        ),
                      );
                    },
                    child: Card(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      elevation: 3,
                      child: ListTile(
                        title: Text('Lab: ${item.labsTest.lab}'),
                        subtitle: Text('Test name: ${item.labsTest.testName}'),
                        trailing: Text('₦${item.labsTest.price}'),
                      ),
                    ),
                  );
                },
              ),
            ),
          CheckoutBtn(
            text: 'Checkout: ₦$totalPrice',
            onpressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => const ScheduleScreen()),
            ),
          ),
        ],
      ),
    );
  }
}
