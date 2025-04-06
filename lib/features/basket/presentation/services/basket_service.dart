import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pampa_app/features/basket/presentation/widgets/basket_bottom_sheet.dart';

/// Provider to access the basket service from anywhere in the app
final basketServiceProvider = Provider<BasketService>((ref) {
  return BasketService();
});

/// Service to handle basket operations like showing the bottom sheet
class BasketService {
  /// Shows the basket bottom sheet
  void showBasketBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 1.0,
          minChildSize: 0.5,
          maxChildSize: 1.0,
          builder: (_, controller) {
            return const BasketBottomSheet();
          },
        );
      },
    );
  }
}
