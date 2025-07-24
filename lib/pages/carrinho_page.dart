import 'package:doceria_app/model/item_carrinho.dart';
import 'package:doceria_app/model/pedido.dart';
import 'package:doceria_app/model/endereco.dart';
import 'package:flutter/material.dart';
import 'package:doceria_app/widgets/button_widget.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doceria_app/repository/endereco_repository.dart';
import 'package:doceria_app/repository/pedido_repository.dart';
import 'package:doceria_app/repository/usuario_repository.dart';
import 'package:doceria_app/model/status.dart';

class Carrinho extends StatefulWidget {
  final List<ItemCarrinho> carrinho;

  const Carrinho({super.key, required this.carrinho});

  @override
  State<Carrinho> createState() => _CarrinhoState();
}

class _CarrinhoState extends State<Carrinho> {
  String _formaPagamento = 'Pix';

  Endereco? _selectedAddress;

  final EnderecoRepository _enderecoRepository = EnderecoRepository();
  final PedidoRepository _pedidoRepository = PedidoRepository();
  final UsuarioRepository _usuarioRepository = UsuarioRepository();

  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    _carregarIdUsuarioAtual().then((_) {
      if (_currentUserId != null) {
        _carregarDadosEndereco();
      }
    });
  }

  Future<void> _carregarIdUsuarioAtual() async {
    final prefs = await SharedPreferences.getInstance();
    final currentUserEmail = prefs.getString('current_user_email');
    if (currentUserEmail != null) {
      final user = await _usuarioRepository.getByEmail(currentUserEmail);
      setState(() {
        _currentUserId = user?.id;
      });
    }
  }

  Future<void> _carregarDadosEndereco() async {
    if (_currentUserId == null) {
      _exibirSnackBar(
        'Usuário não logado. Faça login para ver endereços.',
        Colors.redAccent,
      );
      return;
    }
    try {
      final List<Endereco> addresses = await _enderecoRepository.getByUserId(
        _currentUserId!,
      );

      setState(() {
        if (_selectedAddress != null &&
            addresses.any((addr) => addr.id == _selectedAddress!.id)) {
          _selectedAddress = addresses.firstWhere(
            (addr) => addr.id == _selectedAddress!.id,
          );
        } else if (addresses.isNotEmpty) {
          _selectedAddress = addresses.first;
        } else {
          _selectedAddress = null;
        }
      });
    } catch (e) {
      print('Erro ao carregar endereço de entrega: $e');
      _exibirSnackBar(
        'Erro ao carregar endereço de entrega.',
        Colors.redAccent,
      );
    }
  }

  Future<void> _mostrarModalSelecaoEndereco() async {
    if (_currentUserId == null) {
      _exibirSnackBar(
        'Você precisa estar logado para selecionar um endereço.',
        Colors.redAccent,
      );
      return;
    }

    List<Endereco> userAddresses = await _enderecoRepository.getByUserId(
      _currentUserId!,
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16),
          height: MediaQuery.of(context).size.height * 0.75,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Selecione um Endereço',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.add_circle_outline,
                      size: 30,
                      color: Color(0xFF963484),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      GoRouter.of(
                        context,
                      ).push('/user_config/meu_endereco').then((_) {
                        _carregarDadosEndereco();
                      });
                    },
                  ),
                ],
              ),
              const Divider(),
              if (userAddresses.isEmpty)
                const Expanded(
                  child: Center(
                    child: Text('Nenhum endereço cadastrado. Adicione um!'),
                  ),
                )
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: userAddresses.length,
                    itemBuilder: (context, index) {
                      final address = userAddresses[index];
                      return Card(
                        color:
                            _selectedAddress?.id == address.id
                                ? const Color(0xFFF3EDF7)
                                : null,
                        margin: const EdgeInsets.symmetric(vertical: 8),
                        child: ListTile(
                          title: Text(
                            '${address.rua}, ${address.numero}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            '${address.bairro}, ${address.cidade} - ${address.estado}',
                          ),
                          trailing:
                              _selectedAddress?.id == address.id
                                  ? const Icon(
                                    Icons.check_circle,
                                    color: Colors.green,
                                  )
                                  : null,
                          onTap: () {
                            setState(() {
                              _selectedAddress = address;
                            });
                            Navigator.of(context).pop();
                          },
                        ),
                      );
                    },
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  double get total => widget.carrinho.fold(
    0,
    (soma, item) => soma + (item.produto.preco * item.quantidade),
  );

  void _incrementarQuantidade(ItemCarrinho item) {
    setState(() {
      item.quantidade++;
    });
  }

  void _decrementarQuantidade(ItemCarrinho item) {
    setState(() {
      if (item.quantidade > 1) {
        item.quantidade--;
      } else {
        widget.carrinho.remove(item);
      }
    });
  }

  Future<void> _finalizarPedido() async {
    if (widget.carrinho.isEmpty) {
      _exibirSnackBar(
        "Seu carrinho está vazio. Adicione itens para finalizar o pedido.",
        Colors.redAccent,
      );
      return;
    }

    if (_currentUserId == null) {
      _exibirSnackBar(
        'Você precisa estar logado para finalizar um pedido.',
        Colors.redAccent,
      );
      GoRouter.of(context).go('/autenticacao');
      return;
    }

    if (_selectedAddress == null) {
      _exibirSnackBar('Selecione um endereço de entrega.', Colors.redAccent);
      _mostrarModalSelecaoEndereco();
      return;
    }

    try {
      final pedido = Pedido(
        userId: _currentUserId!,
        data: DateTime.now(),
        itens: List.from(widget.carrinho),
        formaPagamento: _formaPagamento,
        total: total,
        status: StatusPedido.emPreparacao,
      );

      await _pedidoRepository.insert(pedido);

      setState(() {
        widget.carrinho.clear();
      });

      _exibirSnackBar("Pedido realizad com sucesso!", Colors.green);
      if (context.mounted) {
        GoRouter.of(context).go('/home');
      }
    } catch (e) {
      print('Erro ao realizae pedido: $e');
      _exibirSnackBar(
        "Erro ao realizar pedido. Tente novamente.",
        Colors.redAccent,
      );
    }
  }

  void _exibirSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
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
                                          onPressed:
                                              () =>
                                                  _decrementarQuantidade(item),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.add_circle_outline,
                                          ),
                                          onPressed:
                                              () =>
                                                  _incrementarQuantidade(item),
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
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Endereço de Entrega',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextButton(
                          onPressed: () => _mostrarModalSelecaoEndereco(),
                          child: const Text(
                            'Mudar Endereço',
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xFF963484),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF3EDF7),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child:
                          _currentUserId == null
                              ? const Center(child: CircularProgressIndicator())
                              : _selectedAddress == null
                              ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Nenhum endereço selecionado.',
                                    style: TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: TextButton(
                                      onPressed: () {
                                        GoRouter.of(context)
                                            .push('/user_config/meu_endereco')
                                            .then((_) {
                                              _carregarDadosEndereco();
                                            });
                                      },
                                      child: const Text(
                                        'Adicionar/Gerenciar',
                                        style: TextStyle(
                                          fontSize: 16,
                                          color: Color(0xFF963484),
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                              : Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Rua: ${_selectedAddress!.rua}, ${_selectedAddress!.numero}',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    'Bairro: ${_selectedAddress!.bairro}',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    'Cidade: ${_selectedAddress!.cidade} - ${_selectedAddress!.estado}',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    'CEP: ${_selectedAddress!.cep}',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  if (_selectedAddress!.complemento != null &&
                                      _selectedAddress!.complemento!.isNotEmpty)
                                    Text(
                                      'Complemento: ${_selectedAddress!.complemento}',
                                      style: const TextStyle(fontSize: 18),
                                    ),
                                ],
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
