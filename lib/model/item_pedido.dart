class ItemPedido {
  int? id;
  String pedidoId;
  String produtoId;
  int quantidade;
  double precoUnitario;

  ItemPedido({
    this.id,
    required this.pedidoId,
    required this.produtoId,
    required this.quantidade,
    required this.precoUnitario,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'pedido_id': pedidoId,
      'produto_id': produtoId,
      'quantidade': quantidade,
      'preco_unitario': precoUnitario,
    };
  }

  factory ItemPedido.fromMap(Map<String, dynamic> map) {
    return ItemPedido(
      id: map['id'],
      pedidoId: map['pedido_id'],
      produtoId: map['produto_id'],
      quantidade: map['quantidade'],
      precoUnitario: map['preco_unitario'],
    );
  }
}
