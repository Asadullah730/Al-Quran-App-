import 'package:flutter/material.dart';

Widget customTextField(
  String hintText, {
  bool isPassword = false,
  String? Function(String?)? validator,
  TextEditingController? controller,
  Icon? prefixIcon,
}) {
  return TextFormField(
    validator: validator,
    controller: controller,
    obscureText: isPassword ? true : false,
    autocorrect: true,
    decoration: InputDecoration(
      hintText: hintText,
      fillColor: Colors.grey.shade300,
      filled: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      prefixIcon: Icon(
        prefixIcon != null ? prefixIcon.icon : Icons.abc,
        color: Colors.green[400],
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
    ),
  );
}
