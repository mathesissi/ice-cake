import 'package:doceria_app/widgets/button_widget.dart';
import 'package:doceria_app/widgets/input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

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

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Center(
              child: Text(
                'Ice&Cake',
                style: TextStyle(
                  fontSize: 75,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'league_gothic',
                  color: Color(0xFF963484),
                ),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(50.0),
              child: Form(
                key: _formkey,
                child: Center(
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Visibility(
                          visible: !isLogin,
                          child: TextFormField(
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
                        ),
                        SizedBox(height: 25),
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

                        SizedBox(height: 20),
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
                        SizedBox(height: 20),
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
                              SizedBox(height: 20),
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
                        SizedBox(height: 50),
                        ButtonPadrao(
                          text: (isLogin ? 'Login' : 'Cadastrar'),
                          onPressed: () {
                            buttonPrincipal();
                          },
                        ),

                        SizedBox(height: 20),

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
              ),
            ),
          ],
        ),
      ),
    );
  }

  void buttonPrincipal() {
    if (!_formkey.currentState!.validate()) {
      return;
    }

    if (!isLogin && !isChecked) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.redAccent,
          content: Text('Você precisa aceitar os termos para continuar.'),
        ),
      );
      return;
    }

    GoRouter.of(context).go('/home');
  }
}
