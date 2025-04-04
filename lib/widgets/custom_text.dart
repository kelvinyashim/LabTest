import 'package:flutter/material.dart';
import 'package:test_ease/constants/color.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final void Function()? pass;
  final Widget? suffixIcon;
  final Icon icon;

  const CustomTextFormField({
    super.key,
    required this.hintText,
    this.isPassword = false,
    this.onSaved,
    this.validator,
    this.suffixIcon,
    required this.icon,
    this.pass,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      padding: const EdgeInsets.symmetric(vertical: 16),
      height: 70,
      decoration: BoxDecoration(
        color: const Color.fromARGB(62, 213, 210, 210),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        onSaved: onSaved,
        decoration: InputDecoration(
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          prefixIcon: icon,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
          suffixIcon:
              isPassword
                  ? IconButton(
                    icon: Icon(
                      isPassword ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.greenBtn,
                      size: 20,
                    ),
                    onPressed: pass,
                  )
                  : null,
        ),
        validator: validator,
        obscureText: isPassword,
      ),
    );
  }
}
