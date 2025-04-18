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
    final mediaQuery = MediaQuery.of(context);
    final bottomPadding = mediaQuery.padding.bottom;
    final topPadding = mediaQuery.padding.top;
    final screenHeight = mediaQuery.size.height;

    // Calculamos el tamaño inicial basado en la altura de la pantalla
    // Dejamos espacio para el notch/cámara y la barra de navegación
    final initialSize =
        (screenHeight - topPadding - bottomPadding) / screenHeight;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(top: topPadding, bottom: bottomPadding),
          child: DraggableScrollableSheet(
            initialChildSize: initialSize,
            minChildSize: 0.5,
            maxChildSize: 1.0,
            snap: true,
            snapSizes: const [0.5, 0.75, 1.0],
            builder: (_, controller) {
              return Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                child: const BasketBottomSheet(),
              );
            },
          ),
        );
      },
    );
  }
}
