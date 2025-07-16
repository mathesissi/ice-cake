import 'dart:convert';
import 'package:doceria_app/model/item_pedido.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HistoricoPedidosPage extends StatefulWidget {
  const HistoricoPedidosPage({super.key});

  @override
  State<HistoricoPedidosPage> createState() => _HistoricoPedidosPageState();
}

class _HistoricoPedidosPageState extends State<HistoricoPedidosPage> {
  List<Pedido> _pedidos = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPedidos();
  }

  Future<void> _loadPedidos() async {
    final prefs = await SharedPreferences.getInstance();
    final pedidosStringList = prefs.getStringList('pedidos_historico') ?? [];
    setState(() {
      _pedidos = pedidosStringList
          .map((pedidoString) => Pedido.fromJson(jsonDecode(pedidoString)))
          .toList()
          .reversed 
          .toList();
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
        backgroundColor: Color(0xFFFAD6FA),
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _pedidos.isEmpty
              ? const Center(
                  child: Text(
                    'Nenhum pedido feito ainda.',
                    style: TextStyle(fontSize: 30),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _pedidos.length,
                  itemBuilder: (context, index) {
                    final pedido = _pedidos[index];
                    final dataFormatada = DateFormat(
                      'dd/MM/yyyy – HH:mm',
                    ).format(pedido.data);
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      elevation: 3,
                      margin: const EdgeInsets.only(bottom: 16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Pedido em $dataFormatada',
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const Divider(height: 20),
                            ...pedido.itens.map(
                              (item) => Padding(
                                padding: const EdgeInsets.symmetric(vertical: 2.0),
                                child: Text(
                                  '${item.quantidade}x ${item.produto.nome}',
                                  style: const TextStyle(fontSize: 25),
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Pagamento: ${pedido.formaPagamento}',
                              style: const TextStyle(fontSize: 25),
                            ),
                            Text(
                              'Total: R\$ ${pedido.total.toStringAsFixed(2)}',
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFB100A5),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Status: ${pedido.status}',
                              style: TextStyle(
                                fontSize: 25,
                                color: pedido.status == 'Finalizado'
                                    ? Colors.green
                                    : Colors.orange,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}