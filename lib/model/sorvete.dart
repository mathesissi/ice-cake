import 'package:doceria_app/model/produto.dart';

class Sorvete extends Produto {
  String sabor;
  String mlTamanho;

  Sorvete({
    required String nome,
    required String descricao,
    required double preco,
    required this.sabor,
    required this.mlTamanho,
  }) : super(nome, descricao, preco, 'Sorvete');

  @override
  Map<String, dynamic> toJson() {
    final json = super.toJson();
    json.addAll({
      'sabor': sabor,
      'mlTamanho': mlTamanho,
    });
    return json;
  }

  factory Sorvete.fromJson(Map<String, dynamic> json) {
    return Sorvete(
      nome: json['nome'],
      descricao: json['descricao'],
      preco: json['preco'],
      sabor: json['sabor'],
      mlTamanho: json['mlTamanho'],
    );
  }

  @override
  void exibirDetalhes() {
    print('Sorvete: $nome, Sabor: $sabor, Tamanho: $mlTamanho');
  }
}