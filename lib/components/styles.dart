import 'package:flutter/material.dart';

const primaryColor = Color(0xffF4A261);
const warningColor = Color(0xFFE9C46A);
const dangerColor = Color(0xFFE76F51);
const successColor = Color(0xFF2A9D8F);
const greyColor = Color(0xFFAFAFAF);

TextStyle headerStyle({int level = 1, bool dark = true}) {
  List<double> levelSize = [30, 24, 20];
  return TextStyle(
    fontSize: levelSize[level - 1],
    fontWeight: FontWeight.bold,
    color: dark ? Colors.black : Colors.white,
  );
}

final buttonStyle = ElevatedButton.styleFrom(
  padding: const EdgeInsets.symmetric(vertical: 15),
  backgroundColor: primaryColor,
);
