import 'package:doceria_app/model/produto.dart';

class ItemCarrinho {
  final Produto produto;
  int quantidade;

  ItemCarrinho({required this.produto, this.quantidade = 1});

  Map<String, dynamic> toJson() {
    return {
      'produto': produto.toJson(),
      'quantidade': quantidade,
    };
  }

  factory ItemCarrinho.fromJson(Map<String, dynamic> json) {
    return ItemCarrinho(
      produto: Produto.fromJson(json['produto']),
      quantidade: json['quantidade'],
    );
  }
}