import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarrosselWidget extends StatelessWidget {
  CarrosselWidget({super.key});

  final List<String> imgList = [
    'https://cdn-productdbimages.barry-callebaut.com/sites/default/files/styles/mdp_web_gm_chocac-detail/public/externals/d73ed7c82007f2c7d6b1615a80920207.jpg?itok=p8W4PzRn',
    'https://docemania.com.br/wp-content/uploads/2018/04/Fatia-Leite-Ninho-Morango.png',
    'https://guiadacozinha.com.br/wp-content/uploads/2019/10/bolo-cenoura-chocolate-768x619.jpg',
    'https://fornerialuce.com.br/media/catalog/product/cache/ddf067874bab918a6d0d08738c3b500b/m/o/morango_com_chantilly.jpg',
    'https://puertoketo.cl/cdn/shop/files/2_3ede2083-89ca-48ba-882e-ee902944b1fb.png?v=1724705426',
    'https://static.itdg.com.br/images/1200-630/d67039c3ae791ed32e8d2912251c9495/312799-original-1-2-.jpg',
    'https://img.freepik.com/fotos-premium/sorvete-de-pistache_107389-1355.jpg',
    'https://www.selectasorvetes.com/wp-content/uploads/sites/2/2023/07/sorvete-doce-de-leite-com-crocante-de-nozes.jpg',
    'https://thumbs.dreamstime.com/b/descubra-o-sabor-intenso-do-conte%C3%BAdo-gelado-de-sorvete-chocolate-artesanal-design-art%C3%ADstico-e-como-fundo-para-pintura-parede-323965352.jpg',
  ];

  @override
  Widget build(BuildContext context) {
    if (imgList.isEmpty) {
      return const SizedBox(
        height: 250,
        child: Center(
          child: Text('Nenhuma imagem estática disponível para o carrossel.'),
        ),
      );
    }

    return CarouselSlider.builder(
      itemCount: imgList.length,
      itemBuilder: (context, index, realIndex) {
        final imageUrl = imgList[index];
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 6),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              width: double.infinity,
              errorBuilder: (context, error, stackTrace) {
                print(
                  'Erro ao carregar imagem do carrossel: $imageUrl - $error',
                );
                return const Icon(
                  Icons.broken_image,
                  size: 50,
                  color: Colors.grey,
                );
              },
            ),
          ),
        );
      },
      options: CarouselOptions(
        height: 250,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        autoPlayCurve: Curves.fastOutSlowIn,
        enableInfiniteScroll: true,
        autoPlayAnimationDuration: const Duration(milliseconds: 800),
        viewportFraction: 0.8,
      ),
    );
  }
}
