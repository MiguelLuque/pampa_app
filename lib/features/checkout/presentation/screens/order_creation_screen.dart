import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pampa_app/core/domain/models/order.dart';
import 'package:pampa_app/features/checkout/application/order_creation_provider.dart';
import 'package:pampa_app/features/checkout/presentation/widgets/pickup_date_selector.dart';
import 'package:pampa_app/features/checkout/presentation/widgets/pickup_time_selector.dart';

class CheckoutScreen extends HookConsumerWidget {
  const CheckoutScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderCreationState = ref.watch(checkoutProvider);
    final notesController = useTextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Crear Pedido'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Progress indicator showing the current step (similar to the image)
            const LinearProgressIndicator(value: 0.25), // 1st step out of 4
            const SizedBox(height: 8),

            // Step indicators
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _StepIndicator(number: 1, title: 'Pedido', isActive: true),
                _StepIndicator(number: 2, title: 'Pago', isActive: false),
                _StepIndicator(number: 3, title: 'Envío', isActive: false),
                _StepIndicator(number: 4, title: 'Confirmado', isActive: false),
              ],
            ),
            const SizedBox(height: 24),

            // Date picker
            const Text(
              'Fecha de Recogida',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const PickupDateSelector(),
            const SizedBox(height: 16),

            // Time selection (morning/afternoon)
            const Text(
              'Hora de Recogida',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const PickupTimeSelector(),
            const SizedBox(height: 16),

            // Additional notes
            const Text(
              'Notas adicionales',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: notesController,
              maxLines: 3,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Instrucciones especiales para su pedido...',
              ),
            ),

            const Spacer(),

            // Totals and continue button
            Column(
              children: [
                // Order summary (subtotal, shipping, total)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [Text('Subtotal'), Text('€18.20')],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [Text('Gastos de envío'), Text('€2.50')],
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Text(
                      'Total',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '€20.70',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 16),

                // Continue button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                    ),
                    onPressed:
                        orderCreationState.isSubmitting
                            ? null
                            : () =>
                                ref
                                    .read(checkoutProvider.notifier)
                                    .proceedToPayment(),
                    child:
                        orderCreationState.isSubmitting
                            ? const CircularProgressIndicator(
                              color: Colors.white,
                            )
                            : const Text('Proceder al Pago'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int number;
  final String title;
  final bool isActive;

  const _StepIndicator({
    required this.number,
    required this.title,
    required this.isActive,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 16,
          backgroundColor:
              isActive ? Theme.of(context).primaryColor : Colors.grey[300],
          child: Text(
            number.toString(),
            style: TextStyle(
              color: isActive ? Colors.white : Colors.grey[600],
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          title,
          style: TextStyle(
            color: isActive ? Theme.of(context).primaryColor : Colors.grey[600],
            fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ],
    );
  }
}
