import 'package:doceria_app/pages/apresentacao.dart';
import 'package:doceria_app/pages/autenticacao_page.dart';
import 'package:doceria_app/pages/home_page.dart';
import 'package:doceria_app/pages/onboarding_home.dart';
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
  ],
);
