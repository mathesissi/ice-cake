import 'package:doceria_app/widgets/button_widget.dart';
import 'package:doceria_app/widgets/input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doceria_app/model/usuario.dart';
import 'package:doceria_app/repository/usuario_repository.dart';

class AutenticacaoPage extends StatefulWidget {
  const AutenticacaoPage({super.key});

  @override
  State<AutenticacaoPage> createState() => _AutenticacaoPageState();
}

class _AutenticacaoPageState extends State<AutenticacaoPage> {
  bool isLogin = true;
  bool isChecked = false;

  final _formkey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _cpfController = TextEditingController();
  final _telefoneController = TextEditingController();

  final UsuarioRepository _usuarioRepository = UsuarioRepository();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _cpfController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const Text(
                'Ice&Cake',
                style: TextStyle(
                  fontSize: 75,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'league_gothic',
                  color: Color(0xFF963484),
                ),
              ),
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(50.0),
                child: Form(
                  key: _formkey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Visibility(
                        visible: !isLogin,
                        child: Column(
                          children: [
                            TextFormField(
                              style: const TextStyle(fontSize: 25),
                              controller: _nameController,
                              decoration: getInputDecoration(
                                'Nome',
                                Icons.person,
                              ),
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'O nome não pode ser vazio';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              style: const TextStyle(fontSize: 25),
                              controller: _cpfController,
                              decoration: getInputDecoration(
                                'CPF',
                                Icons.badge_outlined,
                              ),
                              keyboardType: TextInputType.number,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'O CPF não pode ser vazio';
                                }
                                if (value.length != 11) {
                                  return 'O CPF deve conter 11 dígitos';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              style: const TextStyle(fontSize: 25),
                              controller: _telefoneController,
                              decoration: getInputDecoration(
                                'Telefone',
                                Icons.phone,
                              ),
                              keyboardType: TextInputType.phone,
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'O telefone não pode ser vazio';
                                }
                                if (value.length < 10 || value.length > 11) {
                                  return 'O telefone deve ter 10 ou 11 dígitos';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 25),
                      TextFormField(
                        style: const TextStyle(fontSize: 25),
                        controller: _emailController,
                        decoration: getInputDecoration('Email', Icons.email),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'O email não pode ser vazio';
                          }
                          if (!value.contains('@') || !value.contains('.')) {
                            return 'O email não é válido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        style: const TextStyle(fontSize: 25),
                        controller: _passwordController,
                        decoration: getInputDecoration('Senha', Icons.lock),
                        obscureText: true,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'A senha não pode ser vazia';
                          }
                          if (value.length < 7) {
                            return 'A senha deve ter no mínimo 7 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      Visibility(
                        visible: !isLogin,
                        child: Column(
                          children: [
                            TextFormField(
                              style: const TextStyle(fontSize: 25),
                              controller: _confirmPasswordController,
                              decoration: getInputDecoration(
                                'Confirmar Senha',
                                Icons.lock,
                              ),
                              obscureText: true,
                              validator: (String? value) {
                                if (value == null || value.isEmpty) {
                                  return 'Confirme a senha';
                                }
                                if (value != _passwordController.text) {
                                  return 'As senhas não coincidem';
                                }
                                return null;
                              },
                            ),
                            const SizedBox(height: 20),
                            Row(
                              children: [
                                Checkbox(
                                  value: isChecked,
                                  onChanged: (value) {
                                    setState(() {
                                      isChecked = value!;
                                    });
                                  },
                                ),
                                TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Li e concordo com os termos',
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 86, 38, 199),
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold,
                                      decoration: TextDecoration.underline,
                                      decorationColor: Color.fromARGB(
                                        255,
                                        86,
                                        38,
                                        199,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 50),
                      ButtonPadrao(
                        text: (isLogin ? 'Login' : 'Cadastrar'),
                        onPressed: () {
                          buttonPrincipal();
                        },
                      ),
                      const SizedBox(height: 20),
                      ButtonAlternativo(
                        onPressed: () {
                          setState(() {
                            isLogin = !isLogin;
                          });
                        },
                        text: (!isLogin ? 'Conecte-se' : 'Cadastra-se'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> buttonPrincipal() async {
    if (!_formkey.currentState!.validate()) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();

    if (isLogin) {
      final enteredEmail = _emailController.text;
      final enteredPassword = _passwordController.text;

      try {
        final Usuario? user = await _usuarioRepository.getByEmail(enteredEmail);

        if (user != null && user.senha == enteredPassword) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.green,
              content: Text('Login realizado com sucesso!'),
            ),
          );
          await prefs.setBool('isLoggedIn', true);

          await prefs.setString('current_user_email', user.email);
          GoRouter.of(context).go('/home');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text('E-mail ou senha incorretos.'),
            ),
          );
        }
      } catch (e) {
        print('Erro durante o login: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text('Ocorreu um erro ao tentar fazer login.'),
          ),
        );
      }
    } else {
      if (!isChecked) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text('Você precisa aceitar os termos para continuar.'),
          ),
        );
        return;
      }

      final newUsuario = Usuario(
        nome: _nameController.text,
        email: _emailController.text,
        senha: _passwordController.text,
        cpf: int.parse(_cpfController.text),
        telefone:
            _telefoneController.text.isEmpty ? null : _telefoneController.text,
        dataCadastro: DateTime.now().toIso8601String(),
      );

      try {
        final existingUser = await _usuarioRepository.getByEmail(
          newUsuario.email,
        );
        if (existingUser != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text('Este e-mail já está cadastrado.'),
            ),
          );
          return;
        }
        final existingCpfUser = await _usuarioRepository.getByCpf(
          newUsuario.cpf.toString(),
        );
        if (existingCpfUser != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              backgroundColor: Colors.redAccent,
              content: Text('Este CPF já está cadastrado.'),
            ),
          );
          return;
        }

        int id = await _usuarioRepository.insert(newUsuario);

        print('Usuário cadastrado com sucesso! ID: $id');

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.green,
            content: Text('Cadastro realizado com sucesso!'),
          ),
        );
        await prefs.setBool('isLoggedIn', true);
        await prefs.setString('current_user_email', newUsuario.email);

        GoRouter.of(context).go('/home');
      } catch (e) {
        print('Erro durante o cadastro: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.redAccent,
            content: Text('Ocorreu um erro ao tentar cadastrar.'),
          ),
        );
      }
    }
  }
}
