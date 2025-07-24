import 'package:doceria_app/model/item_carrinho.dart';
import 'package:doceria_app/model/produto.dart';
import 'package:doceria_app/pages/apresentacao.dart';
import 'package:doceria_app/pages/autenticacao_page.dart';
import 'package:doceria_app/pages/carrinho_page.dart';
import 'package:doceria_app/pages/home_page.dart';
import 'package:doceria_app/pages/onboarding/onboarding_home.dart';
import 'package:doceria_app/pages/pedido_detalhes_page.dart';
import 'package:doceria_app/pages/produto_detalhe_page.dart';
import 'package:doceria_app/pages/profileItems/profile_dados.dart';
import 'package:doceria_app/pages/profileItems/profile_enderecos.dart';
import 'package:doceria_app/pages/profileItems/profile_historico.dart';
import 'package:doceria_app/pages/user_config_page.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

final router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenOnboarding = prefs.getBool('hasSeenOnboarding') ?? false;
    final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
    final bool isAuthRoute = state.fullPath == '/autenticacao';
    final bool isOnboardingRoute =
        state.fullPath == '/' || state.fullPath == '/onboarding';
    final bool isHomeRoute = state.fullPath == '/home';

    if (!hasSeenOnboarding) {
      ;
      return isOnboardingRoute ? null : '/';
    }
    if (!isLoggedIn) {
      if (isHomeRoute) {
        return null;
      }
      if (!isAuthRoute) {
        ;
        return '/autenticacao';
      }
      return null;
    }

    if (isLoggedIn && (isOnboardingRoute || isAuthRoute)) {
      return '/home';
    }
    return null;
  },
  routes: [
    GoRoute(path: '/', builder: (context, state) => const Apresentacao()),
    GoRoute(
      path: '/onboarding',
      pageBuilder: (context, state) => MaterialPage(child: OnboardingHome()),
    ),
    GoRoute(
      path: '/autenticacao',
      builder: (context, state) => const AutenticacaoPage(),
    ),
    GoRoute(path: '/home', builder: (context, state) => const HomePage()),
    GoRoute(
      path: '/home/user_config',
      builder: (context, state) => const UserConfigPage(),
    ),
    GoRoute(
      path: '/user_config/meus_dados',
      builder: (context, state) => const MeusDados(),
    ),
    GoRoute(
      path: '/user_config/meu_endereco',
      builder: (context, state) => const ProfileEnderecosPage(),
    ),
    GoRoute(
      path: '/user_config/minhas_compras',
      builder: (context, state) {
        return const HistoricoPedidosPage();
      },
    ),
    GoRoute(
      path: '/home/carrinho',
      builder: (context, state) {
        final carrinho = state.extra as List<ItemCarrinho>? ?? [];
        return Carrinho(carrinho: carrinho);
      },
    ),
    GoRoute(
      path: '/user_config/minhas_compras/:pedidoId',
      builder: (context, state) {
        final pedidoId = int.parse(state.pathParameters['pedidoId']!);
        return PedidoDetalhePage(pedidoId: pedidoId);
      },
    ),
    GoRoute(
      path: '/produto_detalhe',
      builder: (context, state) {
        final Map<String, dynamic> args = state.extra as Map<String, dynamic>;
        final Produto produto = args['produto'] as Produto;
        final Function(Produto, int) onAddToCart =
            args['onAddToCart'] as Function(Produto, int);
        return ProdutoDetalhePage(produto: produto, onAddToCart: onAddToCart);
      },
    ),
  ],
);
