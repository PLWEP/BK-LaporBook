import 'package:flutter/material.dart';

const primaryColor = Color(0xffF3B95F);
const warningColor = Color(0xFFD04848);
const dangerColor = Color(0xFFF3B95F);
const successColor = Color(0xFF96E9C6);
const greyColor = Color(0xFFAFAFAF);

TextStyle headerStyle({int level = 1, bool dark = true}) {
  List<double> levelSize = [30, 24, 20, 18, 16, 12];
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
