class Usuario {
  int? id;
  String nome;
  String email;
  String senha;
  int cpf;
  String? telefone;
  String dataCadastro;

  Usuario({
    this.id,
    required this.nome,
    required this.email,
    required this.senha,
    required this.cpf,
    this.telefone,
    required this.dataCadastro,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nome': nome,
      'email': email,
      'senha': senha,
      'cpf': cpf,
      'telefone': telefone,
      'dataCadastro': dataCadastro,
    };
  }

  factory Usuario.fromMap(Map<String, dynamic> map) {
    return Usuario(
      id: map['id'],
      nome: map['nome'],
      email: map['email'],
      senha: map['senha'],
      cpf: map['cpf'],
      telefone: map['telefone'],
      dataCadastro: map['dataCadastro'],
    );
  }
}
