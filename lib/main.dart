import 'package:doceria_app/routers/router.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doceria_app/database/db.dart';
import 'package:doceria_app/repository/produto_repository.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DB.instance.database;
  await ProdutoRepository().seedProducts();

  final prefs = await SharedPreferences.getInstance();
  final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;

  runApp(MyApp(initialRoute: hasSeenOnboarding ? '/autenticacao' : '/'));
}

class MyApp extends StatelessWidget {
  final String initialRoute;
  const MyApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'ice&cake',
      theme: ThemeData(
        fontFamily: 'Dongle',
        appBarTheme: const AppBarTheme(
          titleTextStyle: TextStyle(
            color: Color(0xFF963484),
            fontSize: 35,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),

      routerConfig: router,
    );
  }
}
