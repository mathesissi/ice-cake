abstract class Produto {
  String? id;
  String nome;
  String descricao;
  String? detalhadaDescricao;
  double preco;
  String? imageUrl;
  String tipo;

  Produto({
    this.id,
    required this.nome,
    required this.descricao,
    this.detalhadaDescricao,
    required this.preco,
    this.imageUrl,
    required this.tipo,
  });

  void exibirDetalhes();

  Map<String, dynamic> toMap();
}
