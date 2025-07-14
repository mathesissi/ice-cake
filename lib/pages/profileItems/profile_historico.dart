import 'package:doceria_app/model/item_pedido.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HistoricoPedidosPage extends StatelessWidget {
  final List<Pedido> pedidos;

  const HistoricoPedidosPage({super.key, required this.pedidos});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Pedidos'),
        backgroundColor: Color(0xFFFAD6FA),
        foregroundColor: Colors.black,
        centerTitle: true,
      ),
      body:
          pedidos.isEmpty
              ? const Center(
                child: Text(
                  'Nenhum pedido feito ainda.',
                  style: TextStyle(fontSize: 18),
                ),
              )
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: pedidos.length,
                itemBuilder: (context, index) {
                  final pedido = pedidos[index];
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
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ...pedido.itens.map(
                            (item) => Text(
                              '${item.quantidade}x ${item.produto.nome}',
                              style: const TextStyle(fontSize: 14),
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Pagamento: ${pedido.formaPagamento}',
                            style: const TextStyle(fontSize: 14),
                          ),
                          Text(
                            'Total: R\$ ${pedido.total.toStringAsFixed(2)}',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFB100A5),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Status: ${pedido.status}',
                            style: TextStyle(
                              fontSize: 13,
                              color:
                                  pedido.status == 'Finalizado'
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
