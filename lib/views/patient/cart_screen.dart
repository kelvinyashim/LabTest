import 'package:flutter/material.dart';
import 'package:test_ease/constants/color.dart';
import 'package:test_ease/main.dart';
import 'package:test_ease/views/patient/order/schedule_screen.dart';
import 'package:test_ease/widgets/checkout_btn.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final box = cartBox.values.length;
    

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
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: box,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.all(10),
                  elevation: 3,
                  child: ListTile(
                    title: Text(
                      'Lab:  ${cartBox.values.elementAt(index).labsTest.lab}',
                    ),
                    subtitle: Text(
                      'Test name: ${cartBox.values.elementAt(index).labsTest.testName}',
                    ),
                    trailing: Text(
                      'Price: ${cartBox.values.elementAt(index).labsTest.price}',
                    ),
                  ),
                );
              },
            ),
          ),
          CheckoutBtn(onpressed: () =>    Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => ScheduleScreen())),),

        ],
      ),
    );
  }
}
