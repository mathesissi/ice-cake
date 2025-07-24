import 'package:doceria_app/model/item_carrinho.dart';
import 'package:doceria_app/model/status.dart';

class Pedido {
  int? id;
  int userId;
  final DateTime data;
  final List<ItemCarrinho> itens;
  final String formaPagamento;
  final double total;
  final StatusPedido status;

  Pedido({
    this.id,
    required this.userId,
    required this.data,
    required this.itens,
    required this.formaPagamento,
    required this.total,
    this.status = StatusPedido.emPreparacao,
  });

  Map<String, dynamic> toMap() {
    final Map<String, dynamic> map = {
      'user_id': userId,
      'data': data.toIso8601String(),
      'formaPagamento': formaPagamento,
      'total': total,
      'status': statusToString(status),
    };
    if (id != null) {
      map['id'] = id;
    }
    return map;
  }

  factory Pedido.fromMap(Map<String, dynamic> map) {
    return Pedido(
      id: map['id'],
      userId: map['user_id'],
      data: DateTime.parse(map['data']),
      itens: [],
      formaPagamento: map['formaPagamento'],
      total: map['total'],
      status: stringToStatus(map['status']),
    );
  }
}
