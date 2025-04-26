import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pampa_app/features/checkout/application/order_creation_provider.dart';

class PickupDateSelector extends HookConsumerWidget {
  const PickupDateSelector({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final orderCreationState = ref.watch(checkoutProvider);
    final dateFormat = DateFormat('d MMMM yyyy', 'es');

    // Get the minimum allowed date (7 days from now)
    final now = DateTime.now();
    final minDate = DateTime(now.year, now.month, now.day + 7);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Calendar widget
        Container(
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(8),
          ),
          child: CalendarDatePicker(
            initialDate: orderCreationState.pickupDate ?? minDate,
            firstDate: minDate,
            lastDate: DateTime(now.year + 1, now.month, now.day),
            onDateChanged: (date) {
              ref.read(checkoutProvider.notifier).updatePickupDate(date);
            },
            selectableDayPredicate: (DateTime day) {
              // Allow selection only if date is at least 7 days from now
              return day.isAfter(now.add(const Duration(days: 6)));
            },
          ),
        ),

        const SizedBox(height: 12),

        // Selected date display
        if (orderCreationState.pickupDate != null)
          Text(
            'Fecha seleccionada: ${dateFormat.format(orderCreationState.pickupDate!)}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
      ],
    );
  }
}
