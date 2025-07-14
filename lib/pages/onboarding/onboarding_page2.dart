import 'package:flutter/material.dart';

class OnboardingPage2 extends StatelessWidget {
  const OnboardingPage2({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF400057),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              'asset/images/apresentacao/img3.png',
              width: 400,
              height: 350,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 1),
              child: Text(
                "Preocupado com o Açucar?",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 60,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Dongle',
                  height: 0.9,
                ),
              ),
            ),

            const SizedBox(height: 40),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Temos delícias para todos os gostos. Escolha com tranquilidade e aproveite cada momento."',
                style: TextStyle(
                  color: Color.fromARGB(255, 243, 97, 241),
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  height: 0.7,
                ),
              ),
            ),
            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }
}
