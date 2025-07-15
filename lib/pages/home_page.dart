import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:doceria_app/model/bolo.dart';
import 'package:doceria_app/model/item_carrinho.dart';
import 'package:doceria_app/model/produto.dart';
import 'package:doceria_app/model/sorvete.dart';
import 'package:doceria_app/model/torta.dart';
import 'package:doceria_app/widgets/carrossel_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Certifique-se de importar este também para CarouselController

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _currentIndex = 0;
  List<Produto> _produtos = [];
  List<ItemCarrinho> _carrinho = [];
  // 1. Cria uma instância do CarouselController
  final CarouselController _carouselController =
      CarouselController(); // Linha adicionada/corrigida aqui

  @override
  void initState() {
    super.initState();
    _updateProdutos();
  }

  void _updateProdutos() {
    setState(() {
      switch (_currentIndex) {
        case 0:
          _produtos = [
            Bolo(
              nome: 'Bolo de Chocolate com Brigadeiro',
              descricao: 'Massa fofinha de chocolate com cobertura gourmet.',
              preco: 68,
              categoria: 'Comum',
              pedacos: 12,
            ),
            Bolo(
              nome: 'Bolo de Leite Ninho com Morango',
              descricao:
                  'Camadas de creme de leite Ninho com morangos frescos.',
              preco: 75,
              categoria: 'Comum',
              pedacos: 12,
            ),
            Bolo(
              nome: 'Bolo de Cenoura com Chocolate',
              descricao:
                  'Clássico brasileiro com cobertura de brigadeiro caseiro.',
              preco: 60,
              categoria: 'Comum',
              pedacos: 12,
            ),
          ];
          break;
        case 1:
          _produtos = [
            Torta(
              nome: 'Torta de Morango com Chantilly',
              descricao: 'Recheio cremoso e cobertura generosa de morangos.',
              preco: 68,
              categoria: 'Doce',
              peso: 1.2,
            ),
            Torta(
              nome: 'Torta de Chocolate Belga',
              descricao: '70% cacau com recheio trufado e ganache.',
              preco: 72,
              categoria: 'Doce',
              peso: 1.3,
            ),
            Torta(
              nome: 'Torta Holandesa',
              descricao:
                  'Base crocante com creme branco e cobertura de chocolate meio amargo.',
              preco: 75,
              categoria: 'Doce',
              peso: 1.5,
            ),
          ];
          break;
        case 2:
          _produtos = [
            Sorvete(
              nome: 'Sorvete de Pistache Premium',
              descricao: 'Com pasta natural de pistache. Sabor sofisticado.',
              preco: 9,
              sabor: 'Pistache',
              mlTamanho: '100',
            ),
            Sorvete(
              nome: 'Sorvete de Doce de Leite com Nozes',
              descricao:
                  'Pedaços crocantes de nozes e doce de leite argentino.',
              preco: 7,
              sabor: 'Doce de Leite',
              mlTamanho: '100',
            ),
            Sorvete(
              nome: 'Sorvete de Chocolate Intenso',
              descricao:
                  'Feito com chocolate nobre, textura cremosa e sabor marcante.',
              preco: 7,
              sabor: 'Chocolate',
              mlTamanho: '100',
            ),
          ];
          break;
        default:
          _produtos = [];
      }
    });
  }

  // Mapeia o índice do produto na lista atual para o índice da imagem no carrossel global.
  // IMPORTANTE: Esta lógica depende diretamente da ordem das imagens em imgList no CarrosselWidget
  // e da ordem dos produtos em _produtos. Mantenha-os sincronizados.
  int _mapProductIndexToCarouselIndex(int productListIndex) {
    int baseIndex = 0;
    switch (_currentIndex) {
      case 0: // Bolos: Imagens 0, 1, 2
        baseIndex = 0;
        break;
      case 1: // Tortas: Imagens 3, 4, 5
        baseIndex = 3;
        break;
      case 2: // Sorvetes: Imagens 6, 7, 8
        baseIndex = 6;
        break;
    }
    return baseIndex + productListIndex;
  }

  void _adicionarAoCarrinho(Produto produto) {
    setState(() {
      final index = _carrinho.indexWhere(
        (item) => item.produto.nome == produto.nome,
      );
      if (index >= 0) {
        _carrinho[index].quantidade++;
      } else {
        _carrinho.add(ItemCarrinho(produto: produto, quantidade: 1));
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${produto.nome} adicionado ao carrinho!'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final items = <Widget>[
      const Icon(Icons.cake_outlined, size: 30, color: Colors.white),
      const Icon(Icons.pie_chart_outline, size: 30, color: Colors.white),
      const Icon(Icons.icecream_outlined, size: 30, color: Colors.white),
    ];

    final titulo =
        _currentIndex == 0
            ? 'BOLOS ARTESANAIS'
            : _currentIndex == 1
            ? 'TORTAS ARTESANAIS'
            : 'SORVETES GOURMET (100g)'; // Corrigi o texto para 100g aqui também

    final emoji =
        _currentIndex == 0
            ? '🎂'
            : _currentIndex == 1
            ? '🍰'
            : '🍦';

    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      onPressed:
                          () => GoRouter.of(context).push('/home/user_config'),
                      icon: const Icon(
                        Icons.person,
                        size: 32,
                        color: Color(0xFF4B2753),
                      ),
                    ),
                    Stack(
                      children: [
                        IconButton.filled(
                          onPressed: () {
                            GoRouter.of(
                              context,
                            ).push('/home/carrinho', extra: _carrinho);
                          },
                          icon: const Icon(Icons.shopping_cart),
                          style: IconButton.styleFrom(
                            backgroundColor: Color(0xFFF68CDF),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.all(16),
                          ),
                        ),
                        if (_carrinho.isNotEmpty)
                          Positioned(
                            right: 6,
                            top: 6,
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.white,
                              ),
                              child: Text(
                                '${_carrinho.length}',
                                style: const TextStyle(
                                  fontSize: 12,
                                  color: Color(0xFF4B2753),
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              // 2. Passa o controller para o CarrosselWidget
              CarrosselWidget(
                carouselController: _carouselController,
              ), // Linha corrigida aqui
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                child: Row(
                  children: [
                    Text(emoji, style: const TextStyle(fontSize: 32)),
                    const SizedBox(width: 8),
                    Text(
                      titulo,
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  itemCount: _produtos.length,
                  itemBuilder: (context, index) {
                    final produto = _produtos[index];
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: const Icon(
                              Icons.add_circle_outline,
                              color: Color(0xFF4B2753),
                              size: 28,
                            ),
                            onPressed: () => _adicionarAoCarrinho(produto),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // 3. Usa TextButton ou GestureDetector para o título
                                TextButton(
                                  style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero,
                                    alignment: Alignment.centerLeft,
                                  ),
                                  onPressed: () {
                                    // Mapeia o índice do produto para o índice da imagem no carrossel
                                    final carouselIndex =
                                        _mapProductIndexToCarouselIndex(index);
                                  },
                                  child: Text(
                                    produto.nome,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 30,
                                      color:
                                          Colors.black, // Cor do texto do botão
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  produto.descricao,
                                  style: const TextStyle(
                                    fontSize: 26,
                                    color: Color(0xFF4B4B4B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            'R\$ ${produto.preco.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          bottomNavigationBar: CurvedNavigationBar(
            index: _currentIndex,
            items: items,
            backgroundColor: Colors.transparent,
            color: const Color(0xFFFAD6FA),
            buttonBackgroundColor: const Color(0xFFF68CDF),
            height: 70,
            animationDuration: const Duration(milliseconds: 300),
            animationCurve: Curves.easeInOut,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
                _updateProdutos();
              });
            },
          ),
        ),
      ),
    );
  }
}
