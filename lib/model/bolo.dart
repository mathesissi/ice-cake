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
  }) : super(nome, descricao, preco);

  @override
  void exibirDetalhes() {
    print('Bolo: $nome');
    print('Descrição: $descricao');
    print('Preço: R\$ $preco');
    print('Categoria: $categoria');
    print('Número de pedaços: $pedacos');
  }
}
