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

InputDecoration inputEndereco(String label, IconData icon) {
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon, color: Colors.purple),
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.0)),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: Color(0xFF963484), width: 2.0),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10.0),
      borderSide: const BorderSide(color: Colors.grey, width: 1.0),
    ),
    labelStyle: const TextStyle(color: Colors.grey),
  );
}
