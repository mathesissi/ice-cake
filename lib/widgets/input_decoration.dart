import 'package:flutter/material.dart';

InputDecoration getInputDecoration(String label, IconData icon) {
  return InputDecoration(
    prefixIcon: Icon(icon),
    hintText: label,
    hintStyle: TextStyle(
      color: const Color.fromARGB(255, 0, 0, 0),
      fontSize: 25,
    ),
    filled: true,
    fillColor: const Color(0xFFBBACE4),

    contentPadding: EdgeInsets.all(10),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16.0),
      borderSide: BorderSide.none,
    ),
  );
}
