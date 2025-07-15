import 'package:doceria_app/widgets/profile_widget.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserConfigPage extends StatefulWidget {
  const UserConfigPage({super.key});

  @override
  State<UserConfigPage> createState() => _UserConfigPageState();
}

class _UserConfigPageState extends State<UserConfigPage> {
  String _userName = 'Nome do Usuário';
  @override
  void initState() {
    super.initState();
    _loadUserName();
  }

  Future<void> _loadUserName() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _userName = prefs.getString('user_name') ?? 'Usuário';
    });
  }

  String _getFirstLetter(String name) {
    if (name.isEmpty) {
      return '';
    }
    return name[0].toUpperCase();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              IconButton(
                onPressed: () {
                  GoRouter.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back),
              ),
              ClipPath(
                clipper: MyCustomClipper(),
                child: Container(
                  height: 220,
                  width: double.infinity,
                  color: const Color.fromRGBO(210, 41, 193, 1),
                ),
              ),
              Positioned(
                bottom: -30,
                child: CircleAvatar(
                  radius: 90,
                  backgroundColor: Colors.deepPurple,

                  child: Text(
                    _getFirstLetter(_userName),
                    style: const TextStyle(
                      fontSize: 80,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 80),

          Text(_userName, style: const TextStyle(fontSize: 50)),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                ProfileMenuItem(
                  icon: Icons.person,
                  text: 'Meus dados',
                  onTap: () {
                    GoRouter.of(context).push('/user_config/meus_dados');
                  },
                ),
                ProfileMenuItem(
                  icon: Icons.location_on,
                  text: 'Meu endereço',
                  onTap: () {
                    GoRouter.of(context).push('/user_config/meu_endereco');
                  },
                ),
                ProfileMenuItem(
                  icon: Icons.history,
                  text: 'Minhas compras',
                  onTap: () {
                    GoRouter.of(context).push('/user_config/minhas_compras');
                  },
                ),
                ProfileMenuItem(
                  icon: Icons.login_outlined,
                  text: 'Sair',
                  onTap: () {
                    GoRouter.of(context).go('/autenticacao');
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MyCustomClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height * 0.8);
    path.quadraticBezierTo(
      size.width / 2,
      size.height * 0.6,
      size.width,
      size.height * 0.8,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
