import 'package:flutter/material.dart';

Widget ButtonPadrao({required String text, required VoidCallback onPressed}) {
  return FilledButton(
    style: FilledButton.styleFrom(
      elevation: 5,
      shadowColor: const Color.fromARGB(146, 0, 0, 0),
      backgroundColor: Color.fromARGB(255, 138, 0, 135),
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

Widget ButtonAlternativo({
  required String text,
  required VoidCallback onPressed,
}) {
  return FilledButton(
    style: FilledButton.styleFrom(
      elevation: 5,
      shadowColor: const Color.fromARGB(146, 0, 0, 0),
      backgroundColor: Color.fromARGB(255, 255, 189, 249),
      fixedSize: Size(250, 60),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
    ),
    onPressed: onPressed,
    child: Text(
      text,
      style: const TextStyle(
        color: Color.fromARGB(255, 151, 28, 175),
        fontSize: 45,
        fontWeight: FontWeight.bold,
      ),
    ),
  );
}
