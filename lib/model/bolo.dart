import 'package:doceria_app/model/produto.dart';

class Bolo extends Produto {
  String categoria;
  int pedacos;

  Bolo({
    required String nome,
    required String descricao,
    required double preco,
    required this.categoria,
    required this.pedacos,
  }) : super(nome, descricao, preco, 'Bolo');

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'categoria': categoria,
      'pedacos': pedacos,
    });
    return json;
  }

  factory Bolo.fromJson(Map<String, dynamic> json) {
    return Bolo(
      nome: json['nome'],
      descricao: json['descricao'],
      preco: json['preco'],
      categoria: json['categoria'],
      pedacos: json['pedacos'],
    );
  }

  @override
  void exibirDetalhes() {
    print('Bolo: $nome, Categoria: $categoria, Pedaços: $pedacos');
  }
}