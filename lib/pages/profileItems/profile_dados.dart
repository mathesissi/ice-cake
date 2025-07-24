import 'package:doceria_app/widgets/input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:go_router/go_router.dart';
import 'package:doceria_app/model/usuario.dart';
import 'package:doceria_app/repository/usuario_repository.dart';

class MeusDados extends StatefulWidget {
  const MeusDados({super.key});

  @override
  State<MeusDados> createState() => _MeusDadosState();
}

class _MeusDadosState extends State<MeusDados> {
  final _formkey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _cpfController = TextEditingController();
  final _telefoneController = TextEditingController();

  bool _isEditing = false;
  Usuario? _currentUser;
  final UsuarioRepository _usuarioRepository = UsuarioRepository();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _cpfController.dispose();
    _telefoneController.dispose();
    super.dispose();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    final currentUserEmail = prefs.getString('current_user_email');

    if (currentUserEmail != null && currentUserEmail.isNotEmpty) {
      try {
        final Usuario? user = await _usuarioRepository.getByEmail(
          currentUserEmail,
        );
        if (user != null) {
          setState(() {
            _currentUser = user;
            _nameController.text = user.nome;
            _emailController.text = user.email;

            _cpfController.text = user.cpf.toString();

            _telefoneController.text = user.telefone ?? '';
          });
        } else {
          _showSnackBar(
            'Usuário não encontrado no banco de dados.',
            Colors.redAccent,
          );
          _loggoutAndRedirect();
        }
      } catch (e) {
        print('Erro ao carregar dados do usuário: $e');
        _showSnackBar('Erro ao carregar seus dados.', Colors.redAccent);
        _loggoutAndRedirect();
      }
    } else {
      _loggoutAndRedirect();
    }
  }

  Future<void> _salvarDados() async {
    if (!_formkey.currentState!.validate() || _currentUser == null) {
      return;
    }

    try {
      final updatedUser = Usuario(
        id: _currentUser!.id,
        nome: _nameController.text,
        email: _emailController.text,
        senha: _currentUser!.senha,
        cpf: int.parse(_cpfController.text),
        telefone:
            _telefoneController.text.isEmpty ? null : _telefoneController.text,
        dataCadastro: _currentUser!.dataCadastro,
      );

      if (updatedUser.email != _currentUser!.email) {
        final existingUser = await _usuarioRepository.getByEmail(
          updatedUser.email,
        );

        if (existingUser != null && existingUser.id != updatedUser.id) {
          _showSnackBar(
            'Este e-mail já está em uso por outro usuário.',
            Colors.redAccent,
          );
          return;
        }
      }

      int linhasAfetadas = await _usuarioRepository.update(updatedUser);
      if (linhasAfetadas > 0) {
        _showSnackBar('Dados atualizados com sucesso!', Colors.green);

        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('current_user_email', updatedUser.email);

        setState(() {
          _isEditing = false;
          _currentUser = updatedUser;
        });
      } else {
        _showSnackBar(
          'Nenhuma alteração detectada ou erro ao atualizar.',
          Colors.orange,
        );
      }
    } catch (e) {
      print('Erro ao salvar dados: $e');
      _showSnackBar('Ocorreu um erro ao salvar os dados.', Colors.redAccent);
    }
  }

  Future<void> _excluirUsuario() async {
    if (_currentUser == null || _currentUser!.id == null) {
      _showSnackBar('Nenhum usuário para excluir.', Colors.redAccent);
      return;
    }

    bool confirm =
        await showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Confirmar Exclusão'),
              content: const Text(
                'Tem certeza que deseja excluir sua conta? Esta ação é irreversível.',
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(false);
                  },
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.of(dialogContext).pop(true);
                  },
                  child: const Text(
                    'Excluir',
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            );
          },
        ) ??
        false;

    if (confirm) {
      try {
        int linhasAfetadas = await _usuarioRepository.delete(_currentUser!.id!);
        if (linhasAfetadas > 0) {
          _showSnackBar('Sua conta foi excluída com sucesso.', Colors.green);
          await _loggoutAndRedirect();
        } else {
          _showSnackBar(
            'Erro ao excluir conta ou usuário não encontrado.',
            Colors.redAccent,
          );
        }
      } catch (e) {
        print('Erro ao excluir usuário: $e');
        _showSnackBar(
          'Ocorreu um erro ao excluir sua conta.',
          Colors.redAccent,
        );
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: color,
        content: Text(message),
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _loggoutAndRedirect() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('current_user_email');
    if (context.mounted) {
      GoRouter.of(context).go('/autenticacao');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Dados'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Color(0xFF963484)),
        titleTextStyle: const TextStyle(
          color: Color(0xFF963484),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        actions: [
          if (_currentUser != null && _currentUser!.id != null)
            IconButton(
              icon: const Icon(Icons.delete_forever, color: Colors.red),
              onPressed: _excluirUsuario,
              tooltip: 'Excluir Conta',
            ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formkey,
            child: Column(
              children: [
                TextFormField(
                  style: const TextStyle(fontSize: 20),
                  controller: _nameController,
                  decoration: inputEndereco('Nome', Icons.person),
                  readOnly: !_isEditing,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'O nome não pode ser vazio';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                TextFormField(
                  style: const TextStyle(fontSize: 20),
                  controller: _emailController,
                  decoration: inputEndereco('Email', Icons.email),
                  keyboardType: TextInputType.emailAddress,
                  readOnly: !_isEditing,
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
                  style: const TextStyle(fontSize: 20),
                  controller: _cpfController,
                  decoration: inputEndereco('CPF', Icons.badge_outlined),
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  readOnly: !_isEditing,
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
                  style: const TextStyle(fontSize: 20),
                  controller: _telefoneController,
                  decoration: inputEndereco('Telefone', Icons.phone),
                  keyboardType: TextInputType.phone,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  readOnly: !_isEditing,
                  validator: (String? value) {
                    if (value == null || value.isEmpty) {
                      return 'O telefone não pode ser vazio';
                    }
                    if (value.length < 10 || value.length > 11) {
                      return 'O telefone deve ter 10 ou 11 dígitos (com DDD)';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_isEditing) {
              _salvarDados();
            } else {
              _isEditing = true;
            }
          });
        },
        child: Icon(_isEditing ? Icons.save : Icons.edit, color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 214, 3, 158),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
