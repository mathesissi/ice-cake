import 'package:doceria_app/model/status.dart';
import 'package:flutter/material.dart';
import 'package:doceria_app/model/pedido.dart';
import 'package:doceria_app/repository/pedido_repository.dart';
import 'package:intl/intl.dart';

class PedidoDetalhePage extends StatefulWidget {
  final int pedidoId;
  const PedidoDetalhePage({super.key, required this.pedidoId});

  @override
  State<PedidoDetalhePage> createState() => _PedidoDetalhePageState();
}

class _PedidoDetalhePageState extends State<PedidoDetalhePage> {
  Pedido? _pedido;
  bool _isLoading = true;
  final PedidoRepository _pedidoRepository = PedidoRepository();

  @override
  void initState() {
    super.initState();
    _loadPedidoDetails();
  }

  Future<void> _loadPedidoDetails() async {
    setState(() {
      _isLoading = true;
    });
    try {
      final Pedido? loadedPedido = await _pedidoRepository.getById(
        widget.pedidoId,
      );
      setState(() {
        _pedido = loadedPedido;
        _isLoading = false;
      });
    } catch (e) {
      print('Erro ao carregar detalhes do pedido: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar detalhes do pedido.')),
      );
    }
  }

  Future<void> _cancelarPedido() async {
    if (_pedido == null || _pedido!.id == null) return;
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirmar Cancelamento'),
          content: const Text(
            'Tem certeza que deseja cancelar este pedido? Esta ação não pode ser desfeita.',
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Não'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Sim'),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      try {
        if (_pedido!.status == StatusPedido.emPreparacao) {
          await _pedidoRepository.cancelOrder(_pedido!.id!);
          await _loadPedidoDetails();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Pedido cancelado com sucesso!')),
          );
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Não é possível cancelar um pedido neste status.'),
            ),
          );
        }
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Erro ao cancelar pedido. Tente novamente.'),
          ),
        );
      }
    }
  }

  Future<void> _changeOrderStatus(StatusPedido newStatus) async {
    if (_pedido == null || _pedido!.id == null) return;
    try {
      await _pedidoRepository.updateOrderStatus(_pedido!.id!, newStatus);
      await _loadPedidoDetails();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Status do pedido alterado para ${statusToString(newStatus)}!',
          ),
        ),
      );
    } catch (e) {
      print('Erro ao mudar status do pedido: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao mudar status do pedido.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Detalhes do Pedido'),
        backgroundColor: const Color(0xFFFAD6FA),
        actions: [
          if (_pedido != null &&
              _pedido!.status != StatusPedido.entregue &&
              _pedido!.status != StatusPedido.cancelado)
            PopupMenuButton<StatusPedido>(
              onSelected: _changeOrderStatus,
              itemBuilder:
                  (BuildContext context) => <PopupMenuEntry<StatusPedido>>[
                    const PopupMenuItem<StatusPedido>(
                      value: StatusPedido.emPreparacao,
                      child: Text('Em Preparação'),
                    ),
                    const PopupMenuItem<StatusPedido>(
                      value: StatusPedido.aCaminho,
                      child: Text('A Caminho'),
                    ),
                    const PopupMenuItem<StatusPedido>(
                      value: StatusPedido.entregue,
                      child: Text('Entregue'),
                    ),
                  ],
              icon: const Icon(Icons.more_vert),
            ),
        ],
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _pedido == null
              ? const Center(child: Text('Pedido não encontrado.'))
              : SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ID do Pedido: ${_pedido!.id}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Data: ${DateFormat('dd/MM/yyyy HH:mm').format(_pedido!.data)}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Status: ${statusToString(_pedido!.status)}',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color:
                            _pedido!.status == StatusPedido.entregue
                                ? Colors.green
                                : _pedido!.status == StatusPedido.cancelado
                                ? Colors.red
                                : Colors.orange,
                      ),
                    ),
                    const Divider(),
                    const Text(
                      'Itens do Pedido:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ..._pedido!.itens
                        .map(
                          (item) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4),
                            child: Text(
                              '- ${item.quantidade}x ${item.produto.nome} (R\$ ${item.produto.preco.toStringAsFixed(2)})',
                              style: const TextStyle(fontSize: 15),
                            ),
                          ),
                        )
                        .toList(),
                    const Divider(),
                    Text(
                      'Forma de Pagamento: ${_pedido!.formaPagamento}',
                      style: const TextStyle(fontSize: 16),
                    ),
                    Text(
                      'Total: R\$ ${_pedido!.total.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFB100A5),
                      ),
                    ),
                    const SizedBox(height: 20),
                    if (_pedido!.status != StatusPedido.entregue &&
                        _pedido!.status != StatusPedido.cancelado)
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _cancelarPedido,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(vertical: 15),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Cancelar Pedido',
                            style: TextStyle(fontSize: 18, color: Colors.white),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
    );
  }
}
