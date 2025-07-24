import 'package:sqflite/sqflite.dart';
import 'package:doceria_app/database/db.dart';
import 'package:doceria_app/model/endereco.dart';

class EnderecoRepository {
  final DB _db = DB.instance;

  Future<int> insert(Endereco endereco) async {
    Database dbClient = await _db.database;
    return await dbClient.insert(
      'enderecos',
      endereco.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Endereco>> getAll() async {
    Database dbClient = await _db.database;
    final List<Map<String, dynamic>> maps = await dbClient.query('enderecos');
    return List.generate(maps.length, (i) {
      return Endereco.fromMap(maps[i]);
    });
  }

  Future<Endereco?> getById(int id) async {
    Database dbClient = await _db.database;
    final List<Map<String, dynamic>> maps = await dbClient.query(
      'enderecos',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Endereco.fromMap(maps.first);
    }
    return null;
  }

  Future<int> update(Endereco endereco) async {
    Database dbClient = await _db.database;
    return await dbClient.update(
      'enderecos',
      endereco.toMap(),
      where: 'id = ?',
      whereArgs: [endereco.id],
    );
  }

  Future<int> delete(int id) async {
    Database dbClient = await _db.database;
    return await dbClient.delete('enderecos', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Endereco>> getByUserId(int userId) async {
    Database dbClient = await _db.database;
    final List<Map<String, dynamic>> maps = await dbClient.query(
      'enderecos',
      where: 'user_id = ?',
      whereArgs: [userId],
    );
    return List.generate(maps.length, (i) {
      return Endereco.fromMap(maps[i]);
    });
  }
}
