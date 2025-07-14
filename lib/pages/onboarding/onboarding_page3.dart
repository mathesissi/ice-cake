import 'package:doceria_app/widgets/button_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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
            ButtonPadrao(
              text: 'Criar Conta',
              onPressed: () => GoRouter.of(context).go('/autenticacao'),
            ),

            const SizedBox(height: 20),
            ButtonAlternativo(
              text: 'Cardapio',
              onPressed: () => GoRouter.of(context).go('/home'),
            ),

            const SizedBox(height: 90),
          ],
        ),
      ),
    );
  }
}
