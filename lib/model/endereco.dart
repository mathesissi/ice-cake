class Endereco {
  int? id;
  int userId;
  String cep;
  String rua;
  String numero;
  String bairro;
  String cidade;
  String estado;
  String? complemento;

  Endereco({
    this.id,
    required this.userId,
    required this.cep,
    required this.rua,
    required this.numero,
    required this.bairro,
    required this.cidade,
    required this.estado,
    this.complemento,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'cep': cep,
      'rua': rua,
      'numero': numero,
      'bairro': bairro,
      'cidade': cidade,
      'estado': estado,
      'complemento': complemento,
    };
  }

  factory Endereco.fromMap(Map<String, dynamic> map) {
    return Endereco(
      id: map['id'],
      userId: map['user_id'],
      cep: map['cep'],
      rua: map['rua'],
      numero: map['numero'],
      bairro: map['bairro'],
      cidade: map['cidade'],
      estado: map['estado'],
      complemento: map['complemento'],
    );
  }
}
