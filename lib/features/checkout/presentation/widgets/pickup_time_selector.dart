import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pampa_app/core/domain/models/order.dart';
import 'package:pampa_app/features/checkout/application/order_creation_provider.dart';

class PickupTimeSelector extends HookConsumerWidget {
  const PickupTimeSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderCreationState = ref.watch(checkoutProvider);

    return DropdownButtonFormField<PickupTime>(
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      ),
      value: orderCreationState.pickupTime,
      items: [
        DropdownMenuItem(
          value: PickupTime.morning,
          child: const Text('Mañana (9:00 - 12:00)'),
        ),
        DropdownMenuItem(
          value: PickupTime.afternoon,
          child: const Text('Tarde (16:00 - 19:00)'),
        ),
      ],
      onChanged: (value) {
        if (value != null) {
          ref.read(checkoutProvider.notifier).updatePickupTime(value);
        }
      },
    );
  }
}
