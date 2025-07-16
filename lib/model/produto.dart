import 'package:doceria_app/model/bolo.dart';
import 'package:doceria_app/model/sorvete.dart';
import 'package:doceria_app/model/torta.dart';

abstract class Produto {
  String nome;
  String descricao;
  double preco;
  String tipo;

  Produto(this.nome, this.descricao, this.preco, this.tipo);

  void exibirDetalhes();

  Map<String, dynamic> toJson() {
    return {
      'nome': nome,
      'descricao': descricao,
      'preco': preco,
      'tipo': tipo,
    };
  }

  static Produto fromJson(Map<String, dynamic> json) {
    switch (json['tipo']) {
      case 'Bolo':
        return Bolo.fromJson(json);
      case 'Torta':
        return Torta.fromJson(json);
      case 'Sorvete':
        return Sorvete.fromJson(json);
      default:
        throw Exception('Tipo de produto desconhecido: ${json['tipo']}');
    }
  }
}