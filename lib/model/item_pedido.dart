import 'item_carrinho.dart';

class Pedido {
  final DateTime data;
  final List<ItemCarrinho> itens;
  final String formaPagamento;
  final double total;
  final String status;

  Pedido({
    required this.data,
    required this.itens,
    required this.formaPagamento,
    required this.total,
    this.status = 'Finalizado',
  });
}
