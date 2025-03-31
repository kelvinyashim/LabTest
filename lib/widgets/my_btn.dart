import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:test_ease/constants/color.dart';

class MyButton extends StatelessWidget {
  final String text;
  final Function() onTap;

  const MyButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin:  EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.greenBtn,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Material(
        color: Colors.transparent, // Use transparent to show the custom background color
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(16),
          splashColor: Colors.grey.withValues(colorSpace: ColorSpace.displayP3), 
          child: Container(
            
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(30)
            ),
            padding: const EdgeInsets.all(25),
            child: Center(
              child: Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
