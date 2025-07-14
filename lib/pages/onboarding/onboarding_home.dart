import 'package:doceria_app/pages/onboarding/onboarding_page1.dart';
import 'package:doceria_app/pages/onboarding/onboarding_page2.dart';
import 'package:doceria_app/pages/onboarding/onboarding_page3.dart';
import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class OnboardingHome extends StatelessWidget {
  final _controller = PageController();

  OnboardingHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFF2B6FC),
        title: const Text(
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
        child: Column(
          children: [
            Expanded(
              child: PageView(
                controller: _controller,
                children: const [
                  OnboardingPage1(),
                  OnboardingPage2(),
                  OnboardingPage3(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              color: Colors.transparent,
              child: SmoothPageIndicator(
                controller: _controller,
                count: 3,
                effect: const WormEffect(
                  dotColor: Color(0xFF963484),
                  activeDotColor: Color(0xFFF2B6FC),
                  dotHeight: 10,
                  dotWidth: 10,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
