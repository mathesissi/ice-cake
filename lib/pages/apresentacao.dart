import 'package:flutter/material.dart';

class Apresentacao extends StatelessWidget {
  const Apresentacao({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Ice&Cake',
          style: TextStyle(
            fontSize: 45,
            fontWeight: FontWeight.bold,
            fontFamily: 'league_gothic',
            color: Color(0xFF963484),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Image.asset(
                'asset/images/apresentacao/img1.png',
                width: 300,
                height: 300,
              ),
              Text(
                "Que bom te ver aqui!",
                style: TextStyle(
                  color: Color(0xFFC808C2),
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Dongle',
                ),
              ),
              const SizedBox(height: 20),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  'Seja bem-vindo à Ice&Cake – aqui o sabor é especial como você.',
                  style: TextStyle(
                    color: Color(0xFF750073),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 70),
              FilledButton(
                style: FilledButton.styleFrom(
                  elevation: 5,
                  shadowColor: Colors.pinkAccent,
                  fixedSize: Size(250, 60),
                  backgroundColor: Color.fromARGB(255, 214, 77, 189),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                onPressed: () {},
                child: Text(
                  'Continuar',
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 70),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
    );
  }
}
