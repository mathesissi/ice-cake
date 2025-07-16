import 'package:doceria_app/model/produto.dart';

class Torta extends Produto {
  String categoria;
  double peso;

  Torta({
    required String nome,
    required String descricao,
    required double preco,
    required this.categoria,
    required this.peso,
  }) : super(nome, descricao, preco, 'Torta');

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'categoria': categoria,
      'peso': peso,
    });
    return json;
  }

  factory Torta.fromJson(Map<String, dynamic> json) {
    return Torta(
      nome: json['nome'],
      descricao: json['descricao'],
      preco: json['preco'],
      categoria: json['categoria'],
      peso: json['peso'],
    );
  }

  @override
  void exibirDetalhes() {
    print('Torta: $nome, Categoria: $categoria, Peso: ${peso}kg');
  }
}