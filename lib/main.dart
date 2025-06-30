import 'package:doceria_app/pages/apresentacao.dart';
import 'package:doceria_app/pages/home_page.dart';
import 'package:doceria_app/pages/onboarding_home.dart';
import 'package:doceria_app/pages/onboarding_page2.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Doceria App',
      theme: ThemeData(
        fontFamily: 'Dongle',
        appBarTheme: AppBarTheme(
          titleTextStyle: TextStyle(
            color: Color(0xFF963484),
            fontSize: 35,
            fontWeight: FontWeight.bold,
            fontFamily: 'league_gothic',
          ),
        ),
      ),
      home: OnboardingHome(),
    );
  }
}
