import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  DB._();

  static final DB instance = DB._();
  static Database? _database;

  get database async {
    if (_database != null) return _database;

    return await _initDatabase();
  }

  _initDatabase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'doceria.db'),
      version: 1,
      onCreate: _onCreate,
    );
  }

  _onCreate(db, versao) async {
    await db.execute(_usuario);
    await db.execute(_produto);
    await db.execute(_endereco);
    await db.execute(_pedido);
    await db.execute(_itensPedido);
  }

  String get _usuario => '''
    CREATE TABLE usuarios (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      nome TEXT NOT NULL,
      email TEXT UNIQUE NOT NULL,
      senha TEXT NOT NULL,
      cpf INTEGER UNIQUENOT NULL, 
      telefone TEXT,
      dataCadastro TEXT NOT NULL
    );
  ''';

  String get _produto => '''
    CREATE TABLE produtos (
      id TEXT PRIMARY KEY,
      nome TEXT NOT NULL,
      descricao TEXT,
      detalhadaDescricao TEXT,
      preco REAL NOT NULL,
      imageUrl TEXT,
      tipo TEXT NOT NULL,
      categoria_bolo TEXT,
      pedacos_bolo INTEGER,
      sabor_sorvete TEXT,
      ml_tamanho_sorvete TEXT,
      categoria_torta TEXT,
      peso_torta REAL
    );
  ''';

  String get _endereco => '''
    CREATE TABLE enderecos (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      cep TEXT NOT NULL,
      rua TEXT NOT NULL,
      numero TEXT NOT NULL,
      bairro TEXT NOT NULL,
      cidade TEXT NOT NULL,
      estado TEXT NOT NULL,
      complemento TEXT,
      FOREIGN KEY (user_id) REFERENCES usuarios(id) ON DELETE CASCADE
    );
  ''';

  String get _pedido => '''
    CREATE TABLE pedidos (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      user_id INTEGER NOT NULL,
      data TEXT NOT NULL,
      formaPagamento TEXT NOT NULL,
      total REAL NOT NULL,
      status TEXT NOT NULL
    );
  ''';

  String get _itensPedido => '''
    CREATE TABLE itens_pedido (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      pedido_id TEXT NOT NULL,
      produto_id TEXT NOT NULL,
      quantidade INTEGER NOT NULL,
      preco_unitario REAL NOT NULL,
      FOREIGN KEY (pedido_id) REFERENCES pedidos(id) ON DELETE CASCADE,
      FOREIGN KEY (produto_id) REFERENCES produtos(id) ON DELETE CASCADE
    );
  ''';
}
