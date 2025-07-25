import 'package:doceria_app/widgets/input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
    setState(() {
      _nameController.text = prefs.getString('user_name') ?? '';
      _emailController.text = prefs.getString('user_email') ?? '';
      _cpfController.text = prefs.getString('user_cpf') ?? '';
      _telefoneController.text = prefs.getString('user_phone') ?? '';
    });
  }

  Future<void> _salvarDados() async {
    if (_formkey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('user_name', _nameController.text);
      await prefs.setString('user_email', _emailController.text);
      await prefs.setString('user_cpf', _cpfController.text);
      await prefs.setString('user_phone', _telefoneController.text);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Dados atualizados com sucesso!'),
        ),
      );

      setState(() {
        _isEditing = false;
      });
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