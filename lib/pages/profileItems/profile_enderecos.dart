import 'package:doceria_app/widgets/button_widget.dart';
import 'package:doceria_app/widgets/input_decoration.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:doceria_app/model/endereco.dart';
import 'package:doceria_app/repository/endereco_repository.dart';
import 'package:doceria_app/repository/usuario_repository.dart';

class ProfileEnderecosPage extends StatefulWidget {
  const ProfileEnderecosPage({super.key});

  @override
  State<ProfileEnderecosPage> createState() => _ProfileEnderecosPageState();
}

class _ProfileEnderecosPageState extends State<ProfileEnderecosPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _cepController = TextEditingController();
  final TextEditingController _ruaController = TextEditingController();
  final TextEditingController _numeroController = TextEditingController();
  final TextEditingController _bairroController = TextEditingController();
  final TextEditingController _cidadeController = TextEditingController();
  final TextEditingController _estadoController = TextEditingController();
  final TextEditingController _complementoController = TextEditingController();

  final EnderecoRepository _enderecoRepository = EnderecoRepository();
  final UsuarioRepository _usuarioRepository = UsuarioRepository();

  List<Endereco> _addresses = [];
  Endereco? _editingAddress;
  int? _currentUserId;
  bool _isEditing = false;
  @override
  void initState() {
    super.initState();
    _loadCurrentUserId().then((_) {
      if (_currentUserId != null) {
        _loadAddressesData();
      }
    });
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

  Future<void> _loadCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    final currentUserEmail = prefs.getString('current_user_email');
    if (currentUserEmail != null) {
      final user = await _usuarioRepository.getByEmail(currentUserEmail);
      setState(() {
        _currentUserId = user?.id;
      });
    }
  }

  Future<void> _loadAddressesData() async {
    if (_currentUserId == null) return;
    try {
      final List<Endereco> loadedAddresses = await _enderecoRepository
          .getByUserId(_currentUserId!);
      setState(() {
        _addresses = loadedAddresses;
      });
    } catch (e) {
      print('Erro ao carregar endereços: $e');
      _showSnackBar('Erro ao carregar seus endereços.', Colors.redAccent);
    }
  }

  void _openAddressForm([Endereco? addressToEdit]) {
    setState(() {
      _isEditing = addressToEdit != null;
      _editingAddress = addressToEdit;
      _cepController.text = addressToEdit?.cep ?? '';
      _ruaController.text = addressToEdit?.rua ?? '';
      _numeroController.text = addressToEdit?.numero ?? '';
      _bairroController.text = addressToEdit?.bairro ?? '';
      _cidadeController.text = addressToEdit?.cidade ?? '';
      _estadoController.text = addressToEdit?.estado ?? '';
      _complementoController.text = addressToEdit?.complemento ?? '';
    });

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
            top: 20,
            left: 20,
            right: 20,
          ),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _isEditing ? 'Editar Endereço' : 'Adicionar Novo Endereço',
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 20),
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
                    validator: (String? value) {
                      if (value == null || value.isEmpty)
                        return 'O CEP não pode ser vazio';
                      if (value.length != 8)
                        return 'O CEP deve conter 8 dígitos';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    style: const TextStyle(fontSize: 20),
                    controller: _ruaController,
                    decoration: inputEndereco('Rua', Icons.home),
                    validator: (String? value) {
                      if (value == null || value.isEmpty)
                        return 'A rua não pode ser vazia';
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
                    inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    validator: (String? value) {
                      if (value == null || value.isEmpty)
                        return 'O número não pode ser vazio';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    style: const TextStyle(fontSize: 20),
                    controller: _bairroController,
                    decoration: inputEndereco('Bairro', Icons.location_city),
                    validator: (String? value) {
                      if (value == null || value.isEmpty)
                        return 'O bairro não pode ser vazio';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    style: const TextStyle(fontSize: 20),
                    controller: _cidadeController,
                    decoration: inputEndereco('Cidade', Icons.business),
                    validator: (String? value) {
                      if (value == null || value.isEmpty)
                        return 'A cidade não pode ser vazia';
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    style: const TextStyle(fontSize: 20),
                    controller: _estadoController,
                    decoration: inputEndereco('Estado (UF)', Icons.map),
                    validator: (String? value) {
                      if (value == null || value.isEmpty)
                        return 'O estado não pode ser vazio';
                      if (value.length != 2)
                        return 'O estado deve conter 2 letras (UF)';
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
                  const SizedBox(height: 30),
                  ButtonPadrao(
                    text:
                        _isEditing ? 'Salvar Alterações' : 'Adicionar Endereço',
                    onPressed: () {
                      _salvarEndereco();
                      Navigator.of(context).pop();
                    },
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        );
      },
    ).whenComplete(() {
      _cepController.clear();
      _ruaController.clear();
      _numeroController.clear();
      _bairroController.clear();
      _cidadeController.clear();
      _estadoController.clear();
      _complementoController.clear();
      _editingAddress = null;
    });
  }

  void _salvarEndereco() async {
    if (_formKey.currentState!.validate() && _currentUserId != null) {
      final newAddress = Endereco(
        id: _editingAddress?.id,
        userId: _currentUserId!,
        cep: _cepController.text,
        rua: _ruaController.text,
        numero: _numeroController.text,
        bairro: _bairroController.text,
        cidade: _cidadeController.text,
        estado: _estadoController.text,
        complemento:
            _complementoController.text.isEmpty
                ? null
                : _complementoController.text,
      );

      try {
        if (_isEditing && _editingAddress != null) {
          await _enderecoRepository.update(newAddress);
          _showSnackBar('Endereço atualizado com sucesso!', Colors.green);
        } else {
          await _enderecoRepository.insert(newAddress);
          _showSnackBar('Endereço adicionado com sucesso!', Colors.green);
        }
        _loadAddressesData();
      } catch (e) {
        print('Erro ao salvar endereço: $e');
        _showSnackBar('Erro ao salvar endereço.', Colors.redAccent);
      }
    } else if (_currentUserId == null) {
      _showSnackBar(
        'Usuário não logado. Não é possível salvar endereço.',
        Colors.redAccent,
      );
    }
  }

  Future<void> _excluirEndereco(int addressId) async {
    bool confirm =
        await showDialog(
          context: context,
          builder: (BuildContext dialogContext) {
            return AlertDialog(
              title: const Text('Confirmar Exclusão'),
              content: const Text(
                'Tem certeza que deseja remover este endereço?',
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(false),
                  child: const Text('Cancelar'),
                ),
                TextButton(
                  onPressed: () => Navigator.of(dialogContext).pop(true),
                  child: const Text(
                    'Remover',
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
        await _enderecoRepository.delete(addressId);
        _showSnackBar('Endereço removido com sucesso!', Colors.green);
        _loadAddressesData();
      } catch (e) {
        print('Erro ao remover endereço: $e');
        _showSnackBar('Erro ao remover endereço.', Colors.redAccent);
      }
    }
  }

  void _showSnackBar(String message, Color color) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(backgroundColor: color, content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Meus Endereços'),
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
        child: Column(
          children: [
            Expanded(
              child:
                  _currentUserId == null
                      ? const Center(child: CircularProgressIndicator())
                      : _addresses.isEmpty
                      ? const Center(
                        child: Text(
                          'Nenhum endereço cadastrado. Adicione um!',
                          style: TextStyle(fontSize: 20, color: Colors.grey),
                        ),
                      )
                      : ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: _addresses.length,
                        itemBuilder: (context, index) {
                          final address = _addresses[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '${address.rua}, ${address.numero}',
                                    style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  Text(
                                    address.bairro,
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  Text(
                                    '${address.cidade} - ${address.estado}, ${address.cep}',
                                    style: const TextStyle(fontSize: 18),
                                  ),
                                  if (address.complemento != null &&
                                      address.complemento!.isNotEmpty)
                                    Text(
                                      'Complemento: ${address.complemento}',
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  Align(
                                    alignment: Alignment.bottomRight,
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            color: Colors.blue,
                                          ),
                                          onPressed:
                                              () => _openAddressForm(address),
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed:
                                              () =>
                                                  _excluirEndereco(address.id!),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _openAddressForm(),
        child: Icon(Icons.add, color: Colors.white),
        backgroundColor: const Color.fromARGB(255, 214, 3, 158),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }
}
