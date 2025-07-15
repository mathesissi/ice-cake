import 'package:doceria_app/model/item_carrinho.dart';
import 'package:doceria_app/model/item_pedido.dart';
import 'package:flutter/material.dart';
import 'package:doceria_app/widgets/button_widget.dart';
import 'package:shared_preferences/shared_preferences.dart'; // Importar shared_preferences

class Carrinho extends StatefulWidget {
  final List<ItemCarrinho> carrinho;

  const Carrinho({super.key, required this.carrinho});

  @override
  State<Carrinho> createState() => _CarrinhoState();
}

class _CarrinhoState extends State<Carrinho> {
  String _formaPagamento = 'Pix';

  // Variáveis de estado para o endereço
  String _cep = '';
  String _rua = '';
  String _numero = '';
  String _bairro = '';
  String _cidade = '';
  String _estado = '';
  String _complemento = '';

  // Esta lista pedidosHistorico não é mais necessária aqui se você a gerencia globalmente/persistentemente
  // final List<Pedido> pedidosHistorico = [];

  @override
  void initState() {
    super.initState();
    _loadAddressData(); // Carrega os dados do endereço ao iniciar a tela
  }

  // Função para carregar os dados do endereço do SharedPreferences
  Future<void> _loadAddressData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _cep = prefs.getString('address_cep') ?? 'Não informado';
      _rua = prefs.getString('address_rua') ?? 'Não informado';
      _numero = prefs.getString('address_numero') ?? 'N/A';
      _bairro = prefs.getString('address_bairro') ?? 'Não informado';
      _cidade = prefs.getString('address_cidade') ?? 'Não informado';
      _estado = prefs.getString('address_estado') ?? 'N/A';
      _complemento = prefs.getString('address_complemento') ?? '';
    });
  }

  double get total => widget.carrinho.fold(
    0,
    (soma, item) => soma + (item.produto.preco * item.quantidade),
  );

  void _incrementar(ItemCarrinho item) {
    setState(() {
      item.quantidade++;
    });
  }

  void _decrementar(ItemCarrinho item) {
    setState(() {
      if (item.quantidade > 1) {
        item.quantidade--;
      } else {
        widget.carrinho.remove(item);
      }
    });
  }

  void _finalizarPedido() {
    // 1. Impedir a finalização de um pedido vazio
    if (widget.carrinho.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text(
            "Seu carrinho está vazio. Adicione itens para finalizar o pedido.",
          ),
        ),
      );
      return; // Interrompe a função se o carrinho estiver vazio
    }

    final pedido = Pedido(
      data: DateTime.now(),
      itens: List.from(widget.carrinho), // Cria uma cópia da lista de itens
      formaPagamento: _formaPagamento,
      total: total,
    );

    // Em um cenário real, você adicionaria este pedido a uma lista persistente (global/local storage)
    // ou enviaria para um servidor.
    // Exemplo (se você usar pedidosHistoricoGlobal como discutimos anteriormente):
    // pedidosHistoricoGlobal.add(pedido);

    setState(() {
      widget.carrinho.clear(); // Limpa o carrinho após finalizar
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Pedido finalizado com sucesso!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFFFAD6FA),
        elevation: 0,
        title: const Text('Carrinho'),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.black),
        titleTextStyle: const TextStyle(
          color: Colors.black,
          fontSize: 22,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.only(
                  top: 30,
                  left: 16,
                  right: 16,
                  bottom: 20,
                ),
                decoration: const BoxDecoration(
                  color: Color(0xFFFAD6FA),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    bottomRight: Radius.circular(30),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.carrinho.isEmpty)
                      const Text(
                        'Seu carrinho está vazio.',
                        style: TextStyle(fontSize: 22),
                      )
                    else
                      // Exibe os itens do carrinho
                      ...widget.carrinho.map((item) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                '${item.quantidade}x',
                                style: const TextStyle(fontSize: 25),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item.produto.nome,
                                      style: const TextStyle(fontSize: 25),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.remove_circle_outline,
                                          ),
                                          onPressed: () => _decrementar(item),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.add_circle_outline,
                                          ),
                                          onPressed: () => _incrementar(item),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete_outline,
                                          ),
                                          onPressed: () {
                                            setState(() {
                                              widget.carrinho.remove(item);
                                            });
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Text(
                                'R\$ ${(item.produto.preco * item.quantidade).toStringAsFixed(2)}',
                                style: const TextStyle(fontSize: 25),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    // Exibe o total apenas se o carrinho não estiver vazio
                    if (widget.carrinho.isNotEmpty) ...[
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Total',
                            style: TextStyle(
                              fontSize: 50,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'R\$ ${total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 42,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFB100A5),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(height: 20),
              // 2. Campo com o endereço salvo
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Endereço de Entrega',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3EDF7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Rua: $_rua, $_numero',
                            style: const TextStyle(fontSize: 18),
                          ),
                          Text(
                            'Bairro: $_bairro',
                            style: const TextStyle(fontSize: 18),
                          ),
                          Text(
                            'Cidade: $_cidade - $_estado',
                            style: const TextStyle(fontSize: 18),
                          ),
                          Text(
                            'CEP: $_cep',
                            style: const TextStyle(fontSize: 18),
                          ),
                          if (_complemento.isNotEmpty)
                            Text(
                              'Complemento: $_complemento',
                              style: const TextStyle(fontSize: 18),
                            ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Navegar para a tela de edição de endereço
                          Navigator.of(
                            context,
                          ).pushNamed('/user_config/meu_endereco');
                        },
                        child: const Text(
                          'Editar Endereço',
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF963484),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
              const Text(
                'Forma de pagamento',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3EDF7),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children:
                        ['Pix', 'Cartão', 'Dinheiro'].map((forma) {
                          final isSelected = _formaPagamento == forma;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _formaPagamento = forma;
                              });
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color:
                                    isSelected
                                        ? const Color(0xFFF68CDF)
                                        : Colors.transparent,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                forma,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color:
                                      isSelected ? Colors.white : Colors.black,
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                ),
              ),

              const SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ButtonPadrao(
                    text: 'Concluir pedido',
                    onPressed: _finalizarPedido,
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
