import 'package:flutter/material.dart';
import 'package:test_ease/constants/color.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final bool obscureText;
  final void Function()? togglePasswordVisibility;
  final void Function(String?)? onSaved;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final Icon icon;

  const CustomTextFormField({
    super.key,
    required this.hintText,
    required this.icon,
    this.isPassword = false,
    this.obscureText = false,
    this.togglePasswordVisibility,
    this.onSaved,
    this.validator,
    this.keyboardType,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: const Color.fromARGB(62, 213, 210, 210),
        borderRadius: BorderRadius.circular(30),
      ),
      child: TextFormField(
        onSaved: onSaved,
        validator: validator,
        keyboardType: keyboardType ??
            (isPassword ? TextInputType.visiblePassword : TextInputType.text),
        obscureText: isPassword ? obscureText : false,
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
          prefixIcon: icon,
          hintText: hintText,
          hintStyle: TextStyle(color: Colors.grey[500]),
          border: InputBorder.none,
          suffixIcon: isPassword
              ? IconButton(
                  icon: Icon(
                    obscureText ? Icons.visibility_off : Icons.visibility,
                    color: AppColors.greenBtn,
                    size: 20,
                  ),
                  onPressed: togglePasswordVisibility,
                )
              : null,
        ),
      ),
    );
  }
}
