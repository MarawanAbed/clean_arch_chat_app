import 'package:flutter/material.dart';



const kPrimaryColor = Color(0xFF00BF6D);
const kSecondaryColor = Color(0xFFFE9901);
const kContentColorLightTheme = Color(0xFF1D1D35);
const kContentColorDarkTheme = Color(0xFFF5FCF9);
const kWarninngColor = Color(0xFFF3BB1C);
const kErrorColor = Color(0xFFF03738);

myLogo(BuildContext context) {
  final brightness = MediaQuery.of(context).platformBrightness;
  final isDarkMode = brightness == Brightness.dark;

  return Image.asset(
    isDarkMode ? 'assets/images/Logo_dark.png' : 'assets/images/Logo_light.png',
    height: 100,
    width: 100,
  );
}
