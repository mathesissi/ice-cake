class EnderecoModel {
  String cep;
  String rua;
  String numero;
  String bairro;
  String cidade;
  String estado;
  String? complemento;

  EnderecoModel({
    required this.cep,
    required this.rua,
    required this.numero,
    required this.bairro,
    required this.cidade,
    required this.estado,
    this.complemento,
  });
}
