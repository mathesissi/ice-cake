import 'package:flutter/material.dart';

Widget ButtonPadrao({required String text, required VoidCallback onPressed}) {
  return FilledButton(
    style: FilledButton.styleFrom(
      elevation: 5,
      shadowColor: const Color.fromARGB(146, 0, 0, 0),
      backgroundColor: Color.fromARGB(255, 214, 77, 189),
      fixedSize: Size(250, 60),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    onPressed: onPressed,
    child: Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 45,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
