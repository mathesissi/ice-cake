import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:doceria_app/widgets/carrossel_widget.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      Icon(Icons.cake_outlined, size: 30),
      Icon(Icons.pie_chart_outline, size: 30),
      Icon(Icons.icecream_outlined, size: 30),
    ];

    return Container(
      color: Color(0xFFF2B6FC),
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              SizedBox(height: 25),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: const Color.fromARGB(255, 255, 128, 198),
                  ),
                  IconButton.filled(
                    style: IconButton.styleFrom(
                      padding: EdgeInsets.all(29.0),
                      backgroundColor: const Color.fromARGB(255, 255, 149, 215),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.horizontal(
                          left: Radius.circular(26),
                        ),
                      ),
                    ),
                    onPressed: () {},
                    icon: const Icon(Icons.shopping_cart),
                    iconSize: 40,
                    color: Colors.white,
                  ),
                ],
              ),
              SizedBox(height: 25),
              CarrosselWidget(),
            ],
          ),

          bottomNavigationBar: CurvedNavigationBar(
            items: items,
            backgroundColor: Colors.transparent,
            color: Color(0xFFF2B6FC),
            buttonBackgroundColor: const Color.fromARGB(255, 255, 84, 227),
            height: 75,
            animationDuration: Duration(milliseconds: 300),
            animationCurve: Curves.easeInOut,
          ),
        ),
      ),
    );
  }
}
