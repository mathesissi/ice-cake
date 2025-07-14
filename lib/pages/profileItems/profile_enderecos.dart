import 'package:doceria_app/widgets/button_widget.dart';
import 'package:doceria_app/widgets/input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Endereco extends StatefulWidget {
  const Endereco({super.key});

  @override
  State<Endereco> createState() => _EnderecoState();
}

class _EnderecoState extends State<Endereco> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _complementoController = TextEditingController();

  @override
  void dispose() {
    _cepController.dispose();
    _ruaController.dispose();
    _numeroController.dispose();
    _bairroController.dispose();
    _cidadeController.dispose();
    _estadoController.dispose();
    _complementoController.dispose();
    super.dispose();
  }

  void _salvarEndereco() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Endereço salvo com sucesso!')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus endereços'),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Color(0xFF963484)),
        titleTextStyle: const TextStyle(
          color: Color(0xFF963484),
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              const SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        style: const TextStyle(fontSize: 20),
                        controller: _cepController,
                        decoration: inputEndereco(
                          'CEP',
                          Icons.location_on_outlined,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'O CEP não pode ser vazio';
                          }
                          if (value.length != 8) {
                            return 'O CEP deve conter 8 dígitos';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        style: const TextStyle(fontSize: 20),
                        controller: _ruaController,
                        decoration: inputEndereco('Rua', Icons.home),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'A rua não pode ser vazia';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        style: const TextStyle(fontSize: 20),
                        controller: _numeroController,
                        decoration: inputEndereco(
                          'Número',
                          Icons.format_list_numbered,
                        ),
                        keyboardType: TextInputType.number,
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'O número não pode ser vazio';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        style: const TextStyle(fontSize: 20),
                        controller: _bairroController,
                        decoration: inputEndereco(
                          'Bairro',
                          Icons.location_city,
                        ),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'O bairro não pode ser vazio';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        style: const TextStyle(fontSize: 20),
                        controller: _cidadeController,
                        decoration: inputEndereco('Cidade', Icons.business),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'A cidade não pode ser vazia';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        style: const TextStyle(fontSize: 20),
                        controller: _estadoController,
                        decoration: inputEndereco('Estado (UF)', Icons.map),
                        validator: (String? value) {
                          if (value == null || value.isEmpty) {
                            return 'O estado não pode ser vazio';
                          }
                          if (value.length != 2) {
                            return 'O estado deve conter 2 letras (UF)';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        style: const TextStyle(fontSize: 20),
                        controller: _complementoController,
                        decoration: inputEndereco(
                          'Complemento (Opcional)',
                          Icons.add_location_alt,
                        ),
                      ),
                      const SizedBox(height: 50),
                      ButtonPadrao(
                        text: 'Salvar Endereço',
                        onPressed: _salvarEndereco,
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
}
