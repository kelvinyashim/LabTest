import 'package:flutter/material.dart';
import 'package:test_ease/constants/color.dart';
import 'package:test_ease/views/patient/order/schedule_screen.dart';

class CheckoutBtn extends StatelessWidget {
  const CheckoutBtn({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 60, horizontal: 30),
      child: Material(
        color: AppColors.greenBtn,
        shape: const StadiumBorder(),
        elevation: 3,
        child: InkWell(
          splashColor: Colors.grey,
          customBorder: const StadiumBorder(),
          onTap: () {
            Navigator.of(
              context,
            ).push(MaterialPageRoute(builder: (context) => ScheduleScreen()));
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            margin: EdgeInsets.only(bottom: 20, top: 20),
            alignment: Alignment.center,
            child: const Text(
              "Checkout",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
