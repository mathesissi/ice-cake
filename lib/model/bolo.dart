import 'package:doceria_app/model/produto.dart';

class Bolo extends Produto {
  String categoria;
  int pedacos;

  Bolo({
    String? id,
    required String nome,
    required String descricao,
    required String detalhadaDescricao,
    required double preco,
    String? imageUrl,
    required this.categoria,
    required this.pedacos,
  }) : super(
         id: id,
         nome: nome,
         descricao: descricao,
         detalhadaDescricao: detalhadaDescricao,
         preco: preco,
         imageUrl: imageUrl,
         tipo: 'bolo',
       );

  @override
  void exibirDetalhes() {
    print('Bolo: $nome');
    print('Descrição: $descricao');
    print('Preço: R\$ $preco');
    print('Categoria: $categoria');
    print('Número de pedaços: $pedacos');
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
      'categoria_bolo': categoria,
      'pedacos_bolo': pedacos,
    };
  }

  factory Bolo.fromMap(Map<String, dynamic> map) {
    return Bolo(
      id: map['id'],
      nome: map['nome'],
      descricao: map['descricao'],
      detalhadaDescricao: map['detalhadaDescricao'],
      preco: map['preco'],
      imageUrl: map['imageUrl'],
      categoria: map['categoria_bolo'],
      pedacos: map['pedacos_bolo'],
    );
  }
}
