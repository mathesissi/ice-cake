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
  }) : super(nome, descricao, preco);

  @override
  void exibirDetalhes() {
    print('Torta: $nome');
    print('Descrição: $descricao');
    print('Preço: R\$ $preco');
    print('Categoria: $categoria');
    print('Peso: $peso kg');
  }
}
