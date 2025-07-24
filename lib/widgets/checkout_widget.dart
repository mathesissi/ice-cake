import 'package:doceria_app/model/endereco.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:doceria_app/widgets/button_widget.dart';

class CheckoutSectionWidget extends StatelessWidget {
  final Endereco? selectedAddress;
  final String formaPagamento;
  final VoidCallback onFinalizarPedido;
  final Function(String message, Color color) showSnackBar;
  final VoidCallback onLoadAddressData;
  final Function(String method) onPaymentMethodChanged;

  const CheckoutSectionWidget({
    super.key,
    required this.selectedAddress,
    required this.formaPagamento,
    required this.onFinalizarPedido,
    required this.showSnackBar,
    required this.onLoadAddressData,
    required this.onPaymentMethodChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Endereço de Entrega',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3EDF7),
                  borderRadius: BorderRadius.circular(20),
                ),
                child:
                    selectedAddress == null
                        ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Nenhum endereço selecionado.',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  GoRouter.of(
                                    context,
                                  ).push('/user_config/meu_endereco').then((_) {
                                    onLoadAddressData();
                                  });
                                },
                                child: const Text(
                                  'Meus Endereços',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF963484),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        )
                        : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Rua: ${selectedAddress!.rua}, ${selectedAddress!.numero}',
                              style: const TextStyle(fontSize: 18),
                            ),
                            Text(
                              'Bairro: ${selectedAddress!.bairro}',
                              style: const TextStyle(fontSize: 18),
                            ),
                            Text(
                              'Cidade: ${selectedAddress!.cidade} - ${selectedAddress!.estado}',
                              style: const TextStyle(fontSize: 18),
                            ),
                            Text(
                              'CEP: ${selectedAddress!.cep}',
                              style: const TextStyle(fontSize: 18),
                            ),
                            if (selectedAddress!.complemento != null &&
                                selectedAddress!.complemento!.isNotEmpty)
                              Text(
                                'Complemento: ${selectedAddress!.complemento}',
                                style: const TextStyle(fontSize: 18),
                              ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: () {
                                  GoRouter.of(
                                    context,
                                  ).push('/user_config/meu_endereco').then((_) {
                                    onLoadAddressData();
                                  });
                                },
                                child: const Text(
                                  'Editar/Gerenciar Endereço',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Color(0xFF963484),
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),
        const Text(
          'Forma de pagamento',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3EDF7),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children:
                  ['Pix', 'Cartão', 'Dinheiro'].map((forma) {
                    final isSelected = formaPagamento == forma;
                    return GestureDetector(
                      onTap: () {
                        onPaymentMethodChanged(forma);
                        showSnackBar(
                          'Selecione um método de pagamento.',
                          const Color.fromARGB(255, 230, 177, 255),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color:
                              isSelected
                                  ? const Color(0xFFF68CDF)
                                  : Colors.transparent,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          forma,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
            ),
          ),
        ),

        const SizedBox(height: 30),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ButtonPadrao(
              text: 'Concluir pedido',
              onPressed: onFinalizarPedido,
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
