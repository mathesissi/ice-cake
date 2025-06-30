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
  }) : super(nome, descricao, preco);

  @override
  void exibirDetalhes() {
    print('Sorvete: $nome');
    print('Descrição: $descricao');
    print('Preço: R\$ $preco');
    print('Sabor: $sabor');
    print('Tamanho: $mlTamanho ml');
  }
}
