import 'package:flutter/material.dart';

Container CustomButton({
  required String text,
  required VoidCallback onPressed,
  Color backgroundColor = Colors.green,
  double width = double.infinity,
  double height = 50.0,
  bool isLoading = false,
}) {
  return Container(
    width: width,
    height: height,
    decoration: BoxDecoration(
      color: backgroundColor,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(10),
        onTap: !isLoading ? onPressed : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Center(
            child:
                isLoading
                    ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    )
                    : Text(
                      text!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
          ),
        ),
      ),
    ),
  );
}
