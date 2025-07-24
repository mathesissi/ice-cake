import 'package:flutter/material.dart';
import 'package:doceria_app/model/produto.dart';
import 'package:go_router/go_router.dart';
import 'package:doceria_app/model/bolo.dart';
import 'package:doceria_app/model/sorvete.dart';
import 'package:doceria_app/model/torta.dart';

class ProdutoDetalhePage extends StatefulWidget {
  final Produto produto;
  final Function(Produto produto, int quantidade) onAddToCart;

  const ProdutoDetalhePage({
    super.key,
    required this.produto,
    required this.onAddToCart,
  });

  @override
  State<ProdutoDetalhePage> createState() => _ProdutoDetalhePageState();
}

class _ProdutoDetalhePageState extends State<ProdutoDetalhePage> {
  int _quantidade = 1;

  String _detalhesEspecificos() {
    if (widget.produto is Bolo) {
      final bolo = widget.produto as Bolo;
      return 'Categoria: ${bolo.categoria}\nPedaços: ${bolo.pedacos}';
    } else if (widget.produto is Torta) {
      final torta = widget.produto as Torta;
      return 'Categoria: ${torta.categoria}\nPeso: ${torta.peso} kg';
    } else if (widget.produto is Sorvete) {
      final sorvete = widget.produto as Sorvete;
      return 'Sabor: ${sorvete.sabor}\nTamanho: ${sorvete.mlTamanho} ml';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final produto = widget.produto;
    final detalhes = _detalhesEspecificos();

    return Scaffold(
      backgroundColor: const Color(0xFFFDF5FD),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF963484)),
        title: Text(
          produto.nome,
          style: const TextStyle(
            color: Color(0xFF963484),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(16),
                clipBehavior: Clip.antiAlias,
                child:
                    produto.imageUrl?.isNotEmpty == true
                        ? Image.network(
                          produto.imageUrl!,
                          height: 220,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                        : Container(
                          height: 220,
                          alignment: Alignment.center,
                          child: const Text('Imagem não disponível'),
                        ),
              ),

              const SizedBox(height: 20),

              Text(
                produto.nome,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4B2753),
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              Text(
                produto.descricao,
                style: const TextStyle(fontSize: 18, color: Colors.black87),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              if (detalhes.isNotEmpty)
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3EDF7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    detalhes,
                    style: const TextStyle(
                      fontSize: 16,
                      fontStyle: FontStyle.italic,
                      color: Color(0xFF4B2753),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),

              const SizedBox(height: 24),
              const Divider(),

              Text(
                'R\$ ${produto.preco.toStringAsFixed(2)}',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFB100A5),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove_circle_outline, size: 32),
                    onPressed: () {
                      setState(() {
                        if (_quantidade > 1) _quantidade--;
                      });
                    },
                  ),
                  Text(
                    '$_quantidade',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.add_circle_outline, size: 32),
                    onPressed: () {
                      setState(() {
                        _quantidade++;
                      });
                    },
                  ),
                ],
              ),

              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB100A5),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () {
                    widget.onAddToCart(produto, _quantidade);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          '${_quantidade}x ${produto.nome} adicionado ao carrinho!',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                    context.pop();
                  },
                  child: const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.shopping_cart, color: Colors.white),
                      SizedBox(width: 10),
                      Text(
                        'Adicionar ao carrinho',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
