import 'package:doceria_app/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class Apresentacao extends StatelessWidget {
  const Apresentacao({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text('Ice&Cake', style: TextStyle(fontSize: 45)),
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
                  'Seja bem-vindo ao Ice&Cake aqui o sabor é especial como você.',
                  style: TextStyle(
                    color: Color(0xFF750073),
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 70),
              ButtonPadrao(
                text: 'Começar',
                onPressed: () => GoRouter.of(context).go('/onboarding'),
              ),
              const SizedBox(height: 70),
            ],
          ),
        ),
      ),
    );
  }
}
