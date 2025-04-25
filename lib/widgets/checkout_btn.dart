import 'package:flutter/material.dart';
import 'package:test_ease/constants/color.dart';

class CheckoutBtn extends StatelessWidget {
  const CheckoutBtn({super.key, required this.onpressed});
  final void Function() onpressed;

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
          onTap: onpressed,
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
