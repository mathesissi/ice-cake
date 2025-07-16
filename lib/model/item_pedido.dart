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

  Map<String, dynamic> toJson() {
    return {
      'data': data.toIso8601String(),
      'itens': itens.map((item) => item.toJson()).toList(),
      'formaPagamento': formaPagamento,
      'total': total,
      'status': status,
    };
  }

  factory Pedido.fromJson(Map<String, dynamic> json) {
    return Pedido(
      data: DateTime.parse(json['data']),
      itens: (json['itens'] as List)
          .map((itemJson) => ItemCarrinho.fromJson(itemJson))
          .toList(),
      formaPagamento: json['formaPagamento'],
      total: json['total'],
      status: json['status'],
    );
  }
}