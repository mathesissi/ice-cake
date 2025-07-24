import 'package:doceria_app/model/item_pedido.dart';
import 'package:doceria_app/model/status.dart';
import 'package:doceria_app/repository/produto_repository.dart';
import 'package:sqflite/sqflite.dart';
import 'package:doceria_app/database/db.dart';
import 'package:doceria_app/model/pedido.dart';
import 'package:doceria_app/model/item_carrinho.dart';
import 'package:doceria_app/model/produto.dart';

class PedidoRepository {
  final DB _db = DB.instance;

  Future<int> insert(Pedido pedido) async {
    Database dbClient = await _db.database;
    int insertedPedidoId = 0;

    await dbClient.transaction((txn) async {
      insertedPedidoId = await txn.insert(
        'pedidos',
        pedido.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );

      for (var itemCarrinho in pedido.itens) {
        final itemPedidoDB = ItemPedido(
          pedidoId: insertedPedidoId.toString(),
          produtoId: itemCarrinho.produto.id!,
          quantidade: itemCarrinho.quantidade,
          precoUnitario: itemCarrinho.produto.preco,
        );
        await txn.insert('itens_pedido', itemPedidoDB.toMap());
      }
    });
    return insertedPedidoId;
  }

  Future<List<Pedido>> getAll() async {
    Database dbClient = await _db.database;
    final List<Map<String, dynamic>> maps = await dbClient.query('pedidos');
    return List.generate(maps.length, (i) {
      final map = maps[i];
      return Pedido.fromMap(map);
    });
  }

  Future<Pedido?> getById(int id) async {
    Database dbClient = await _db.database;
    final ProdutoRepository produtoRepo = ProdutoRepository();

    final List<Map<String, dynamic>> pedidoMaps = await dbClient.query(
      'pedidos',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (pedidoMaps.isEmpty) return null;
    final pedidoMap = pedidoMaps.first;

    final List<Map<String, dynamic>> itensMaps = await dbClient.query(
      'itens_pedido',
      where: 'pedido_id = ?',
      whereArgs: [id],
    );

    List<ItemCarrinho> itensDoPedido = [];
    for (var itemMap in itensMaps) {
      final itemPedidoDB = ItemPedido.fromMap(itemMap);

      Produto? produtoAssociado = await produtoRepo.getById(
        itemPedidoDB.produtoId,
      );

      if (produtoAssociado != null) {
        itensDoPedido.add(
          ItemCarrinho(
            produto: produtoAssociado,
            quantidade: itemPedidoDB.quantidade,
          ),
        );
      }
    }

    return Pedido(
      id: pedidoMap['id'],
      userId: pedidoMap['user_id'],
      data: DateTime.parse(pedidoMap['data']),
      formaPagamento: pedidoMap['formaPagamento'],
      total: pedidoMap['total'],
      status: stringToStatus(pedidoMap['status']),
      itens: itensDoPedido,
    );
  }

  Future<int> update(Pedido pedido) async {
    Database dbClient = await _db.database;
    return await dbClient.update(
      'pedidos',
      pedido.toMap(),
      where: 'id = ?',
      whereArgs: [pedido.id],
    );
  }

  Future<int> delete(int id) async {
    Database dbClient = await _db.database;
    return await dbClient.delete('pedidos', where: 'id = ?', whereArgs: [id]);
  }

  Future<List<Pedido>> getPedidosByUserId(int userId) async {
    Database dbClient = await _db.database;
    final ProdutoRepository produtoRepo = ProdutoRepository();

    final List<Map<String, dynamic>> pedidoMaps = await dbClient.query(
      'pedidos',
      where: 'user_id = ?',
      whereArgs: [userId],
      orderBy: 'data DESC',
    );

    List<Pedido> pedidosCompletos = [];

    for (var pedidoMap in pedidoMaps) {
      final int pedidoId = pedidoMap['id'];

      final List<Map<String, dynamic>> itensMaps = await dbClient.query(
        'itens_pedido',
        where: 'pedido_id = ?',
        whereArgs: [pedidoId],
      );

      List<ItemCarrinho> itensDoPedido = [];
      for (var itemMap in itensMaps) {
        final itemPedidoDB = ItemPedido.fromMap(itemMap);

        Produto? produtoAssociado = await produtoRepo.getById(
          itemPedidoDB.produtoId,
        );

        if (produtoAssociado != null) {
          itensDoPedido.add(
            ItemCarrinho(
              produto: produtoAssociado,
              quantidade: itemPedidoDB.quantidade,
            ),
          );
        }
      }

      pedidosCompletos.add(
        Pedido(
          id: pedidoMap['id'],
          userId: pedidoMap['user_id'],
          data: DateTime.parse(pedidoMap['data']),
          formaPagamento: pedidoMap['formaPagamento'],
          total: pedidoMap['total'],
          status: stringToStatus(pedidoMap['status']),
          itens: itensDoPedido,
        ),
      );
    }
    return pedidosCompletos;
  }

  Future<int> updateOrderStatus(int pedidoId, StatusPedido newStatus) async {
    Database dbClient = await _db.database;
    return await dbClient.update(
      'pedidos',
      {'status': statusToString(newStatus)},
      where: 'id = ?',
      whereArgs: [pedidoId],
    );
  }

  Future<int> cancelOrder(int pedidoId) async {
    Database dbClient = await _db.database;
    return await dbClient.update(
      'pedidos',
      {'status': statusToString(StatusPedido.cancelado)},
      where: 'id = ?',
      whereArgs: [pedidoId],
    );
  }
}
