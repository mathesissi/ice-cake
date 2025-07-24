import 'package:sqflite/sqflite.dart';
import 'package:doceria_app/database/db.dart';
import 'package:doceria_app/model/produto.dart';
import 'package:doceria_app/model/bolo.dart';
import 'package:doceria_app/model/sorvete.dart';
import 'package:doceria_app/model/torta.dart';

class ProdutoRepository {
  final DB _db = DB.instance;

  Future<int> insert(Produto produto) async {
    Database dbClient = await _db.database;
    return await dbClient.insert(
      'produtos',
      produto.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Produto>> getAll() async {
    Database dbClient = await _db.database;
    final List<Map<String, dynamic>> maps = await dbClient.query('produtos');
    return List.generate(maps.length, (i) {
      final map = maps[i];
      switch (map['tipo']) {
        case 'bolo':
          return Bolo.fromMap(map);
        case 'sorvete':
          return Sorvete.fromMap(map);
        case 'torta':
          return Torta.fromMap(map);
        default:
          throw Exception('Tipo de produto desconhecido: ${map['tipo']}');
      }
    });
  }

  Future<Produto?> getById(String id) async {
    Database dbClient = await _db.database;
    final List<Map<String, dynamic>> maps = await dbClient.query(
      'produtos',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      final map = maps.first;
      switch (map['tipo']) {
        case 'bolo':
          return Bolo.fromMap(map);
        case 'sorvete':
          return Sorvete.fromMap(map);
        case 'torta':
          return Torta.fromMap(map);
        default:
          throw Exception('Tipo de produto desconhecido: ${map['tipo']}');
      }
    }
    return null;
  }

  Future<int> update(Produto produto) async {
    Database dbClient = await _db.database;
    return await dbClient.update(
      'produtos',
      produto.toMap(),
      where: 'id = ?',
      whereArgs: [produto.id],
    );
  }

  Future<int> delete(String id) async {
    Database dbClient = await _db.database;
    return await dbClient.delete('produtos', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> seedProducts() async {
    Database dbClient = await _db.database;
    int count =
        Sqflite.firstIntValue(
          await dbClient.rawQuery('SELECT COUNT(*) FROM produtos'),
        )!;

    if (count == 0) {
      print('Tabela de produtos vazia. Adicionando dados');

      final List<Produto> produtos = [
        Bolo(
          id: 'bolo_choc_brig',
          nome: 'Bolo de Chocolate com Brigadeiro',
          descricao: 'Massa fofinha de chocolate com cobertura gourmet.',
          detalhadaDescricao:
              'Bolo clássico feito com massa de chocolate úmida, recheado com brigadeiro artesanal e finalizado com cobertura cremosa e confeitos.',
          preco: 68.00,
          imageUrl:
              'https://cdn-productdbimages.barry-callebaut.com/sites/default/files/styles/mdp_web_gm_chocac-detail/public/externals/d73ed7c82007f2c7d6b1615a80920207.jpg?itok=p8W4PzRn',
          categoria: 'Comum',
          pedacos: 12,
        ),
        Bolo(
          id: 'bolo_leite_ninho',
          nome: 'Bolo de Leite Ninho com Morango',
          descricao: 'Camadas de creme de leite Ninho com morangos frescos.',
          detalhadaDescricao:
              'Delicioso bolo branco com recheio generoso de creme de leite Ninho e camadas de morangos frescos, decorado com chantilly e raspas de chocolate branco.',
          preco: 75.00,
          imageUrl:
              'https://docemania.com.br/wp-content/uploads/2018/04/Fatia-Leite-Ninho-Morango.png',
          categoria: 'Comum',
          pedacos: 12,
        ),
        Bolo(
          id: 'bolo_cenoura_choc',
          nome: 'Bolo de Cenoura com Chocolate',
          descricao:
              'Tradicional e fofinho, com cobertura generosa de chocolate.',
          detalhadaDescricao:
              'Clássico bolo de cenoura com textura leve, coberto com uma espessa camada de ganache de chocolate meio amargo.',
          preco: 62.00,
          imageUrl:
              'https://guiadacozinha.com.br/wp-content/uploads/2019/10/bolo-cenoura-chocolate-768x619.jpg',
          categoria: 'Comum',
          pedacos: 12,
        ),
        Torta(
          id: 'torta_morango',
          nome: 'Torta de Morango com Chantilly',
          descricao: 'Recheio cremoso e cobertura generosa de morangos.',
          detalhadaDescricao:
              'Torta de massa leve recheada com creme de baunilha e coberta com chantilly fresco e morangos inteiros. Ideal para ocasiões especiais.',
          preco: 68.00,
          imageUrl:
              'https://fornerialuce.com.br/media/catalog/product/cache/ddf067874bab918a6d0d08738c3b500b/m/o/morango_com_chantilly.jpg',
          categoria: 'Doce',
          peso: 1.2,
        ),
        Torta(
          id: 'torta_chocolate_belga',
          nome: 'Torta de Chocolate Belga',
          descricao: 'Feita com chocolate belga 70% e cobertura de ganache.',
          detalhadaDescricao:
              'Torta sofisticada feita com massa de cacau, recheio cremoso e cobertura de ganache de chocolate belga 70% cacau.',
          preco: 78.00,
          imageUrl:
              'https://puertoketo.cl/cdn/shop/files/2_3ede2083-89ca-48ba-882e-ee902944b1fb.png?v=1724705426',
          categoria: 'Premium',
          peso: 1.3,
        ),
        Torta(
          id: 'torta_holandesa',
          nome: 'Torta Holandesa',
          descricao:
              'Clássica torta com biscoito, creme branco e cobertura de chocolate.',
          detalhadaDescricao:
              'Base crocante de biscoito, recheio suave de creme de baunilha e cobertura de chocolate meio amargo. Finalizada com biscoitos ao redor.',
          preco: 72.00,
          imageUrl:
              'https://static.itdg.com.br/images/1200-630/d67039c3ae791ed32e8d2912251c9495/312799-original-1-2-.jpg',
          categoria: 'Doce',
          peso: 1.2,
        ),
        Sorvete(
          id: 'sorvete_pistache',
          nome: 'Sorvete de Pistache Premium',
          descricao: 'Com pasta natural de pistache. Sabor sofisticado.',
          detalhadaDescricao:
              'Sorvete cremoso feito com pasta pura de pistache importado, textura leve e sabor suave, perfeito para paladares exigentes.',
          preco: 9.00,
          imageUrl:
              'https://img.freepik.com/fotos-premium/sorvete-de-pistache_107389-1355.jpg',
          sabor: 'Pistache',
          mlTamanho: '100',
        ),
        Sorvete(
          id: 'sorvete_doce_leite',
          nome: 'Sorvete de Doce de Leite com Nozes',
          descricao: 'Combinação irresistível com pedaços de nozes crocantes.',
          detalhadaDescricao:
              'Sorvete artesanal de doce de leite com pedaços crocantes de nozes caramelizadas. Cremoso e marcante.',
          preco: 9.00,
          imageUrl:
              'https://www.selectasorvetes.com/wp-content/uploads/sites/2/2023/07/sorvete-doce-de-leite-com-crocante-de-nozes.jpg',
          sabor: 'Doce de leite com nozes',
          mlTamanho: '100',
        ),
        Sorvete(
          id: 'sorvete_chocolate_intenso',
          nome: 'Sorvete de Chocolate Intenso',
          descricao: 'Feito com chocolate 70% e textura extra cremosa.',
          detalhadaDescricao:
              'Sorvete encorpado de chocolate intenso 70% cacau, com sabor marcante e textura sedosa. Ideal para chocólatras.',
          preco: 9.00,
          imageUrl:
              'https://thumbs.dreamstime.com/b/descubra-o-sabor-intenso-do-conte%C3%BAdo-gelado-de-sorvete-chocolate-artesanal-design-art%C3%ADstico-e-como-fundo-para-pintura-parede-323965352.jpg',
          sabor: 'Chocolate Intenso',
          mlTamanho: '100',
        ),
      ];

      for (var produto in produtos) {
        await insert(produto);
      }
      print('Dados de produtos iniciais adicionados com sucesso.');
    } else {
      print('Tabela de produtos já contém dados.');
    }
  }
}
