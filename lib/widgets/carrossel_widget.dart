import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarrosselWidget extends StatelessWidget {
  const CarrosselWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> imgList = [
      'asset/images/produtos/promo1.png',
      'asset/images/produtos/promo2.png',
      'asset/images/produtos/promo3.png',
      'asset/images/produtos/promo4.png',
    ];

    return CarouselSlider(
      options: CarouselOptions(
        height: 200.0,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.8,
        autoPlayInterval: const Duration(seconds: 3),
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
      ),
      items:
          imgList
              .map(
                (item) => Center(
                  child: ClipRRect(
                    borderRadius: const BorderRadius.all(Radius.circular(15.0)),
                    child: Image.asset(
                      item,
                      fit: BoxFit.cover,
                      width: 1000,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey[300],
                          child: Center(
                            child: Icon(
                              Icons.image_not_supported,
                              color: Colors.grey[600],
                              size: 50,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              )
              .toList(),
    );
  }
}
