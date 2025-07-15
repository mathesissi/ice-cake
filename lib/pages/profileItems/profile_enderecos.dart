import 'package:doceria_app/widgets/button_widget.dart';
import 'package:doceria_app/widgets/input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadAddressData();
  }

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

  Future<void> _loadAddressData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _cepController.text = prefs.getString('address_cep') ?? '';
      _ruaController.text = prefs.getString('address_rua') ?? '';
      _numeroController.text = prefs.getString('address_numero') ?? '';
      _bairroController.text = prefs.getString('address_bairro') ?? '';
      _cidadeController.text = prefs.getString('address_cidade') ?? '';
      _estadoController.text = prefs.getString('address_estado') ?? '';
      _complementoController.text =
          prefs.getString('address_complemento') ?? '';
    });
  }

  void _salvarEndereco() async {
    if (_formKey.currentState!.validate()) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('address_cep', _cepController.text);
      await prefs.setString('address_rua', _ruaController.text);
      await prefs.setString('address_numero', _numeroController.text);
      await prefs.setString('address_bairro', _bairroController.text);
      await prefs.setString('address_cidade', _cidadeController.text);
      await prefs.setString('address_estado', _estadoController.text);
      await prefs.setString('address_complemento', _complementoController.text);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.green,
          content: Text('Endereço salvo com sucesso!'),
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
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(8),
                        ],
                        readOnly: !_isEditing,
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
                        readOnly: !_isEditing,
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
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        readOnly: !_isEditing,
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
                        readOnly: !_isEditing,
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
                        readOnly: !_isEditing,
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
                        readOnly: !_isEditing,
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
                        readOnly: !_isEditing,
                      ),
                      const SizedBox(height: 50),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          setState(() {
            if (_isEditing) {
              _salvarEndereco();
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
