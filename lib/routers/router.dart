import 'package:doceria_app/model/item_carrinho.dart';
import 'package:doceria_app/model/item_pedido.dart';
import 'package:doceria_app/model/produto.dart';
import 'package:doceria_app/pages/apresentacao.dart';
import 'package:doceria_app/pages/autenticacao_page.dart';
import 'package:doceria_app/pages/carrinho_page.dart';
import 'package:doceria_app/pages/home_page.dart';
import 'package:doceria_app/pages/onboarding/onboarding_home.dart';
import 'package:doceria_app/pages/profileItems/profile_dados.dart';
import 'package:doceria_app/pages/profileItems/profile_enderecos.dart';
import 'package:doceria_app/pages/profileItems/profile_historico.dart';
import 'package:doceria_app/pages/user_config_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final routes = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (context, state) => const Apresentacao()),
    GoRoute(
      path: '/onboarding',
      pageBuilder: (context, state) => MaterialPage(child: OnboardingHome()),
    ),
    GoRoute(
      path: '/autenticacao',
      builder: (context, state) => AutenticacaoPage(),
    ),
    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    GoRoute(
      path: '/home/user_config',
      builder: (context, state) => UserConfigPage(),
    ),
    GoRoute(
      path: '/user_config/meus_dados',
      builder: (context, state) => MeusDados(),
    ),
    GoRoute(
      path: '/user_config/meu_endereco',
      builder: (context, state) => Endereco(),
    ),
    GoRoute(
      path: '/user_config/minhas_compras',
      builder: (context, state) {
        final pedidos = state.extra as List<Pedido>? ?? [];
        return HistoricoPedidosPage(pedidos: pedidos);
      },
    ),
    GoRoute(
      path: '/home/carrinho',
      builder: (context, state) {
        final carrinho = state.extra as List<ItemCarrinho>? ?? [];
        return Carrinho(carrinho: carrinho);
      },
    ),
  ],
);
