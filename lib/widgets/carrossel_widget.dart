import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class CarrosselWidget extends StatelessWidget {
  // Adiciona o CarouselController como um parâmetro obrigatório
  final CarouselController carouselController;

  const CarrosselWidget({super.key, required this.carouselController});

  @override
  Widget build(BuildContext context) {
    final List<String> imgList = [
      'https://cdn-productdbimages.barry-callebaut.com/sites/default/files/styles/mdp_web_gm_chocac-detail/public/externals/d73ed7c82007f2c7d6b1615a80920207.jpg?itok=p8W4PzRn', // Bolo de Chocolate
      'https://docemania.com.br/wp-content/uploads/2018/04/Fatia-Leite-Ninho-Morango.png', // Bolo de Leite Ninho
      'https://guiadacozinha.com.br/wp-content/uploads/2019/10/bolo-cenoura-chocolate-768x619.jpg', // Bolo de Cenoura
      'https://fornerialuce.com.br/media/catalog/product/cache/ddf067874bab918a6d0d08738c3b500b/m/o/morango_com_chantilly.jpg', // Torta de Morango
      'https://puertoketo.cl/cdn/shop/files/2_3ede2083-89ca-48ba-882e-ee902944b1fb.png?v=1724705426', // Torta de Chocolate Belga (usei uma imagem genérica)
      'https://static.itdg.com.br/images/1200-630/d67039c3ae791ed32e8d2912251c9495/312799-original-1-2-.jpg', // Torta Holandesa (usei uma imagem genérica)
      'https://img.freepik.com/fotos-premium/sorvete-de-pistache_107389-1355.jpg', // Sorvete de Pistache
      'https://www.selectasorvetes.com/wp-content/uploads/sites/2/2023/07/sorvete-doce-de-leite-com-crocante-de-nozes.jpg', // Sorvete de Doce de Leite
      'https://thumbs.dreamstime.com/b/descubra-o-sabor-intenso-do-conte%C3%BAdo-gelado-de-sorvete-chocolate-artesanal-design-art%C3%ADstico-e-como-fundo-para-pintura-parede-323965352.jpg', // Sorvete de Chocolate
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
                    child: Image.network(
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
