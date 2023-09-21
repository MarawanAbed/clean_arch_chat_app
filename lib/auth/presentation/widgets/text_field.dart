import 'package:flutter/material.dart';

class AuthFormField extends StatelessWidget {
  final String labelText;
  final IconData prefixIcon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?) validator;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;

  const AuthFormField({
    super.key,
    this.obscureText = false,
    required this.labelText,
    required this.prefixIcon,
    required this.controller,
    required this.keyboardType,
    required this.validator,
    this.suffixIcon,
     this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: onChanged,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: Icon(prefixIcon),
        suffixIcon: suffixIcon,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }
}
