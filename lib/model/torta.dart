import 'package:doceria_app/model/produto.dart';

class Torta extends Produto {
  String categoria;
  double peso;

  Torta({
    String? id,
    required String nome,
    required String descricao,
    required String detalhadaDescricao,
    required double preco,
    String? imageUrl,
    required this.categoria,
    required this.peso,
  }) : super(
         id: id,
         nome: nome,
         descricao: descricao,
         detalhadaDescricao: detalhadaDescricao,
         preco: preco,
         imageUrl: imageUrl,
         tipo: 'torta',
       );

  @override
  void exibirDetalhes() {
    print('Torta: $nome');
    print('Descrição: $descricao');
    print('Preço: R\$ $preco');
    print('Categoria: $categoria');
    print('Peso: $peso kg');
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
      'categoria_torta': categoria,
      'peso_torta': peso,
    };
  }

  factory Torta.fromMap(Map<String, dynamic> map) {
    return Torta(
      id: map['id'],
      nome: map['nome'],
      descricao: map['descricao'],
      detalhadaDescricao: map['detalhadaDescricao'],
      preco: map['preco'],
      imageUrl: map['imageUrl'],
      categoria: map['categoria_torta'],
      peso: map['peso_torta'],
    );
  }
}
