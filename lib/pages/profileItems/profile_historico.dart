import 'package:doceria_app/model/pedido.dart';
import 'package:doceria_app/model/status.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doceria_app/repository/pedido_repository.dart';
import 'package:doceria_app/repository/usuario_repository.dart';

class HistoricoPedidosPage extends StatefulWidget {
  const HistoricoPedidosPage({super.key});

  @override
  State<HistoricoPedidosPage> createState() => _HistoricoPedidosPageState();
}

class _HistoricoPedidosPageState extends State<HistoricoPedidosPage> {
  List<Pedido> _pedidos = [];
  bool _isLoading = true;
  int? _currentUserId;

  final PedidoRepository _pedidoRepository = PedidoRepository();
  final UsuarioRepository _usuarioRepository = UsuarioRepository();

  @override
  void initState() {
    super.initState();
    _loadCurrentUserId().then((_) {
      if (_currentUserId != null) {
        _loadPedidos();
      } else {
        setState(() {
          _isLoading = false;
        });
      }
    });
  }

  Future<void> _loadCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final currentUserEmail = prefs.getString('current_user_email');
    if (currentUserEmail != null) {
      final user = await _usuarioRepository.getByEmail(currentUserEmail);
      setState(() {
        _currentUserId = user?.id;
      });
    }
  }

  Future<void> _loadPedidos() async {
    if (_currentUserId == null) return;
    setState(() {
      _isLoading = true;
    });
    try {
      final List<Pedido> loadedPedidos = await _pedidoRepository
          .getPedidosByUserId(_currentUserId!);

      setState(() {
        _pedidos = loadedPedidos;
        _isLoading = false;
      });
    } catch (e) {
      print('Erro ao carregar histórico de pedidos: $e');
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar histórico de pedidos.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
        backgroundColor: const Color(0xFFFAD6FA),
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body:
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : _pedidos.isEmpty
              ? const Center(
                child: Text(
                  'Nenhum pedido feito ainda.',
                  style: TextStyle(fontSize: 18),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _pedidos.length,
                itemBuilder: (context, index) {
                  final pedido = _pedidos[index];
                  final dataFormatada = DateFormat(
                    'dd/MM/yyyy HH:mm',
                  ).format(pedido.data);
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                    elevation: 3,
                    margin: const EdgeInsets.only(bottom: 16),
                    child: ListTile(
                      onTap: () {
                        GoRouter.of(context)
                            .push('/user_config/minhas_compras/${pedido.id}')
                            .then((_) {
                              _loadPedidos();
                            });
                      },
                      title: Text(
                        'Pedido #${pedido.id} - $dataFormatada',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Total: R\$ ${pedido.total.toStringAsFixed(2)}'),
                          Text(
                            'Status: ${statusToString(pedido.status)}',
                            style: TextStyle(
                              color:
                                  pedido.status == StatusPedido.entregue
                                      ? Colors.green
                                      : pedido.status == StatusPedido.cancelado
                                      ? Colors.red
                                      : Colors.orange,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text(
                            'Itens: ${pedido.itens.map((e) => e.produto.nome).join(', ')}',
                          ),
                        ],
                      ),
                      trailing: const Icon(Icons.arrow_forward_ios),
                    ),
                  );
                },
              ),
    );
  }
}
