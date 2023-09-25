import 'package:flutter/material.dart';

class ElevationVerification extends StatelessWidget {
  const ElevationVerification({
    super.key,
    required this.onPressed,
    required this.label,
    required this.icon,
  });

  final VoidCallback onPressed;
  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon),
      label: Text(
        label,
        style: TextStyle(fontSize: 24),
      ),
    );
  }
}
