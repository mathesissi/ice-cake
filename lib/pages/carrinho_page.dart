import 'dart:convert';
import 'package:doceria_app/model/item_carrinho.dart';
import 'package:doceria_app/model/item_pedido.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CarrinhoPage extends StatefulWidget {
  final List<ItemCarrinho> carrinho;
  const CarrinhoPage({super.key, required this.carrinho});

  @override
  State<CarrinhoPage> createState() => _CarrinhoState();
}

class _CarrinhoState extends State<CarrinhoPage> {
  String _formaPagamento = 'Cartão de Crédito';
  double total = 0;

  @override
  void initState() {
    super.initState();
    _calcularTotal();
  }

  void _calcularTotal() {
    total = widget.carrinho.fold(
        0, (sum, item) => sum + (item.produto.preco * item.quantidade));
  }

  void _removerItem(int index) {
    setState(() {
      widget.carrinho.removeAt(index);
      _calcularTotal();
    });
  }

  void _finalizarPedido() async {
    final prefs = await SharedPreferences.getInstance();
    final cepSalvo = prefs.getString('address_cep') ?? '';

    if (!mounted) return;

    if (cepSalvo.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orange,
          content: Text("Cadastre um endereço antes de finalizar o pedido."),
          duration: Duration(seconds: 3),
        ),
      );
      context.push('/user_config/meus_enderecos');
      return;
    }

    if (widget.carrinho.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            "Seu carrinho está vazio. Adicione itens para finalizar o pedido.",
          ),
        ),
      );
      return;
    }

    final pedido = Pedido(
      data: DateTime.now(),
      itens: List.from(widget.carrinho),
      formaPagamento: _formaPagamento,
      total: total,
    );

    final pedidosSalvos = prefs.getStringList('pedidos_historico') ?? [];
    pedidosSalvos.add(jsonEncode(pedido.toJson()));
    await prefs.setStringList('pedidos_historico', pedidosSalvos);

    setState(() {
      widget.carrinho.clear();
      _calcularTotal();
    });

    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Pedido finalizado com sucesso!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Carrinho'),
        backgroundColor: const Color(0xFFFAD6FA),
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: widget.carrinho.isEmpty
                ? const Center(
                    child: Text(
                    "Seu carrinho está vazio!",
                    style: TextStyle(fontSize: 30),
                  ))
                : ListView.builder(
                    itemCount: widget.carrinho.length,
                    itemBuilder: (context, index) {
                      final item = widget.carrinho[index];
                      return ListTile(
                        title: Text(item.produto.nome),
                        subtitle: Text(
                            '${item.quantidade}x R\$ ${item.produto.preco.toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.remove_circle_outline),
                          onPressed: () => _removerItem(index),
                        ),
                      );
                    },
                  ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                DropdownButton<String>(
                  value: _formaPagamento,
                  isExpanded: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      _formaPagamento = newValue!;
                    });
                  },
                  items: <String>[
                    'Cartão de Crédito',
                    'Cartão de Débito',
                    'Pix',
                    'Dinheiro'
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: const TextStyle(fontSize: 25)),
                    );
                  }).toList(),
                ),
                const SizedBox(height: 16),
                Text(
                  'Total: R\$ ${total.toStringAsFixed(2)}',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      fontSize: 35, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: _finalizarPedido,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFB100A5),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Finalizar Pedido'),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}