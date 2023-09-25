import 'package:flutter/material.dart';

enum MessageType {
  textType,
  imageType,
  text,
  image,
}

MessageType getMessageTypeFromString(String json) {
  switch (json) {
    case 'text':
      return MessageType.textType;
    case 'image':
      return MessageType.imageType;
    default:
      throw Exception('Unsupported MessageType: $json');
  }
}




Widget buildMyButton({
  required String label,
  required Color color,
  required VoidCallback onPressed,
  height,
}) {
  return MaterialButton(
    onPressed: onPressed,
    height: height,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(30),
    ),
    color: color,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ],
    ),
  );
}

class AuthFormField extends StatelessWidget {
  final String labelText;
  final IconData prefixIcon;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool obscureText;
  final String? Function(String?)? validator;
  final Widget? suffixIcon;
  final void Function(String)? onChanged;

  const AuthFormField({
    super.key,
    this.obscureText = false,
    required this.labelText,
    required this.prefixIcon,
    required this.controller,
    required this.keyboardType,
    this.validator,
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