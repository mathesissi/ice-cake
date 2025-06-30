import 'package:doceria_app/widgets/button_widget.dart';
import 'package:flutter/material.dart';

class OnboardingPage3 extends StatelessWidget {
  const OnboardingPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 224, 138, 255),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text(
              'Confira já!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 80,
                fontWeight: FontWeight.bold,
              ),
            ),
            Image.asset(
              'asset/images/apresentacao/img5.png',
              width: 357,
              height: 250,
            ),
            const SizedBox(height: 40),
            ButtonPadrao(text: 'Criar Conta', onPressed: () {}),

            const SizedBox(height: 20),
            FilledButton(
              style: FilledButton.styleFrom(
                elevation: 5,
                shadowColor: const Color.fromARGB(146, 0, 0, 0),
                fixedSize: const Size(250, 60),
                backgroundColor: const Color.fromARGB(255, 255, 169, 251),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: const BorderSide(color: Color(0xFFD64DBD), width: 2),
                ),
              ),
              onPressed: () {
                // ação para navegar ao cardápio
              },
              child: const Text(
                'Cardápio',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }
}
