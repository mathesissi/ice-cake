import 'package:sqflite/sqflite.dart';
import 'package:doceria_app/database/db.dart';
import 'package:doceria_app/model/usuario.dart';

class UsuarioRepository {
  final DB _db = DB.instance;

  Future<int> insert(Usuario usuario) async {
    Database dbClient = await _db.database;
    return await dbClient.insert(
      'usuarios',
      usuario.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Usuario>> getAll() async {
    Database dbClient = await _db.database;
    final List<Map<String, dynamic>> maps = await dbClient.query('usuarios');
    return List.generate(maps.length, (i) {
      return Usuario.fromMap(maps[i]);
    });
  }

  Future<Usuario?> getById(int id) async {
    Database dbClient = await _db.database;
    final List<Map<String, dynamic>> maps = await dbClient.query(
      'usuarios',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Usuario.fromMap(maps.first);
    }
    return null;
  }

  Future<Usuario?> getByCpf(String cpf) async {
    Database dbClient = await _db.database;
    final List<Map<String, dynamic>> maps = await dbClient.query(
      'usuarios',
      where: 'cpf = ?',
      whereArgs: [int.parse(cpf)],
    );
    if (maps.isNotEmpty) {
      return Usuario.fromMap(maps.first);
    }
    return null;
  }

  Future<Usuario?> getByEmail(String email) async {
    Database dbClient = await _db.database;
    final List<Map<String, dynamic>> maps = await dbClient.query(
      'usuarios',
      where: 'email = ?',
      whereArgs: [email],
    );
    if (maps.isNotEmpty) {
      return Usuario.fromMap(maps.first);
    }
    return null;
  }

  Future<int> update(Usuario usuario) async {
    Database dbClient = await _db.database;
    return await dbClient.update(
      'usuarios',
      usuario.toMap(),
      where: 'id = ?',
      whereArgs: [usuario.id],
    );
  }

  Future<int> delete(int id) async {
    Database dbClient = await _db.database;
    return await dbClient.delete('usuarios', where: 'id = ?', whereArgs: [id]);
  }
}
