import 'package:flutter/material.dart';
import 'styles.dart';

InputDecoration customInputDecoration(String hintText, {Widget? suffixIcon}) {
  return InputDecoration(
    hintText: hintText,
    suffixIcon: suffixIcon,
    floatingLabelBehavior: FloatingLabelBehavior.never,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
    ),
  );
}

class InputWidget extends StatelessWidget {
  final String label;
  final StatefulWidget inputField;

  const InputWidget({
    super.key,
    required this.label,
    required this.inputField,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: headerStyle(level: 3)),
        const SizedBox(height: 5),
        Container(
          child: inputField,
        ),
        const SizedBox(height: 15)
      ],
    );
  }
}
