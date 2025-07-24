import 'package:doceria_app/model/produto.dart';

class Sorvete extends Produto {
  String sabor;
  String mlTamanho;

  Sorvete({
    String? id,
    required String nome,
    required String descricao,
    required String detalhadaDescricao,
    required double preco,
    String? imageUrl,
    required this.sabor,
    required this.mlTamanho,
  }) : super(
         id: id,
         nome: nome,
         descricao: descricao,
         detalhadaDescricao: detalhadaDescricao,
         preco: preco,
         imageUrl: imageUrl,
         tipo: 'sorvete',
       );

  @override
  void exibirDetalhes() {
    print('Sorvete: $nome');
    print('Descrição: $descricao');
    print('Preço: R\$ $preco');
    print('Sabor: $sabor');
    print('Tamanho: $mlTamanho ml');
  }

  @override
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'descricao': descricao,
      'detalhadaDescricao': detalhadaDescricao,
      'preco': preco,
      'imageUrl': imageUrl,
      'tipo': tipo,
      'sabor_sorvete': sabor,
      'ml_tamanho_sorvete': mlTamanho,
    };
  }

  factory Sorvete.fromMap(Map<String, dynamic> map) {
    return Sorvete(
      id: map['id'],
      nome: map['nome'],
      descricao: map['descricao'],
      detalhadaDescricao: map['detalhadaDescricao'],
      preco: map['preco'],
      imageUrl: map['imageUrl'],
      sabor: map['sabor_sorvete'],
      mlTamanho: map['ml_tamanho_sorvete'],
    );
  }
}
