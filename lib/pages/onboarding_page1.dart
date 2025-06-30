import 'package:flutter/material.dart';

class OnboardingPage1 extends StatelessWidget {
  const OnboardingPage1({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF2C012F),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              'asset/images/apresentacao/img2.png',
              width: 350,
              height: 300,
            ),
            Text(
              "Vai aí \num docinho ?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 70,
                fontFamily: 'Dongle',
                height: 0.9,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Text(
                'Somos uma doceria especializada em tortas, bolos e sorvetes, preparados com muito amor e carinho',
                style: TextStyle(
                  color: Color.fromARGB(255, 209, 72, 207),
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
