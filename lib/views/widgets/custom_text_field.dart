import 'package:flutter/material.dart';
import '../../constants/app_colors.dart';

class CustomTextFormField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;
  final String? Function(String?)? validator;
  final TextStyle? inputTextStyle;

  const CustomTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.obscureText = false,
    required this.validator,
    this.inputTextStyle, required TextInputAction textInputAction, required TextInputType keyboardType
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: "Input field",
      textField: true,
      hint: "Enter $hintText",
      child: TextFormField(
        obscureText: obscureText,
        controller: controller,
        validator: validator,
        cursorColor: AppColors.blueColor,
        cursorErrorColor: Colors.red,
        textInputAction: TextInputAction.go,
        keyboardType: TextInputType.emailAddress,
        onTapOutside: (event) {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        style: inputTextStyle ?? const TextStyle(color: AppColors.primaryColor),
        decoration: InputDecoration(
          border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            borderSide: BorderSide(color: AppColors.primaryColor),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: AppColors.blueColor,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(
              color: Colors.red,
              width: 2,
            ),
          ),
          hintText: hintText,
          hintStyle: inputTextStyle ?? TextStyle(color: AppColors.primaryColor.withOpacity(0.7)),  // Apply the hint style as well
        ),
      ),
    );
  }
}
