import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:doceria_app/model/item_carrinho.dart';
import 'package:doceria_app/model/produto.dart';
import 'package:doceria_app/widgets/carrossel_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doceria_app/repository/produto_repository.dart';
import 'package:doceria_app/repository/usuario_repository.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final ProdutoRepository _produtoRepository = ProdutoRepository();
  final UsuarioRepository _usuarioRepository = UsuarioRepository();

  Future<bool> verificarLogin(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

    if (!isLoggedIn) {
      GoRouter.of(context).go('/autenticacao');
      return false;
    }

    return true;
  }

  int _currentIndex = 0;
  List<Produto> _produtos = [];
  final List<ItemCarrinho> _carrinho = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _carregarProdutosDoBanco();
  }

  Future<void> _carregarProdutosDoBanco() async {
    setState(() {
      _isLoading = true;
      _produtos = [];
    });
    try {
      List<Produto> todosOsProdutos = await _produtoRepository.getAll();

      String tipoDesejado;
      switch (_currentIndex) {
        case 0:
          tipoDesejado = 'bolo';
          break;
        case 1:
          tipoDesejado = 'torta';
          break;
          break;
        case 2:
          tipoDesejado = 'sorvete';
          break;
        default:
          tipoDesejado = '';
      }

      setState(() {
        _produtos =
            todosOsProdutos.where((p) => p.tipo == tipoDesejado).toList();
        _isLoading = false;
      });
    } catch (e) {
      print('Erro ao carregar produtos do banco de dados: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Erro ao carregar produtos.'),
        ),
      );
    }
  }

  void _updateProdutos() {
    _carregarProdutosDoBanco();
  }

  void _adicionarAoCarrinho(Produto produto, [int quantidade = 1]) {
    setState(() {
      final index = _carrinho.indexWhere(
        (item) => item.produto.id == produto.id,
      );
      if (index >= 0) {
        _carrinho[index].quantidade += quantidade;
      } else {
        _carrinho.add(ItemCarrinho(produto: produto, quantidade: quantidade));
      }
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${quantidade}x ${produto.nome} adicionado ao carrinho!'),
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
            : 'SORVETES GOURMET (100g)';

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
                      onPressed: () async {
                        if (!await verificarLogin(context)) return;
                        GoRouter.of(context).push('/home/user_config');
                      },
                      icon: const Icon(
                        Icons.person,
                        size: 32,
                        color: Color.fromARGB(255, 105, 88, 109),
                      ),
                    ),
                    Stack(
                      children: [
                        IconButton.filled(
                          onPressed: () async {
                            if (!await verificarLogin(context)) return;
                            GoRouter.of(
                              context,
                            ).push('/home/carrinho', extra: _carrinho);
                          },
                          icon: const Icon(Icons.shopping_cart),
                          style: IconButton.styleFrom(
                            backgroundColor: const Color(0xFFF68CDF),
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

              CarrosselWidget(),
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
                child:
                    _isLoading
                        ? const Center(child: CircularProgressIndicator())
                        : _produtos.isEmpty
                        ? const Center(
                          child: Text(
                            'Nenhum produto encontrado para esta categoria.',
                            style: TextStyle(fontSize: 20, color: Colors.grey),
                          ),
                        )
                        : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: _produtos.length,
                          itemBuilder: (context, index) {
                            final produto = _produtos[index];
                            return Padding(
                              padding: const EdgeInsets.symmetric(
                                vertical: 8.0,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  IconButton(
                                    icon: const Icon(
                                      Icons.add_circle_outline,
                                      color: Color(0xFF4B2753),
                                      size: 28,
                                    ),
                                    onPressed:
                                        () => _adicionarAoCarrinho(produto),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        TextButton(
                                          style: TextButton.styleFrom(
                                            padding: EdgeInsets.zero,
                                            alignment: Alignment.centerLeft,
                                          ),
                                          onPressed: () {
                                            GoRouter.of(context).push(
                                              '/produto_detalhe',
                                              extra: {
                                                'produto': produto,
                                                'onAddToCart':
                                                    _adicionarAoCarrinho,
                                              },
                                            );
                                          },
                                          child: Text(
                                            produto.nome,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 30,
                                              color: Colors.black,
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
