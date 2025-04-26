import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pampa_app/core/data/providers/basket_providers.dart';
import 'package:pampa_app/core/router/app_routes.dart';
import 'package:pampa_app/core/theme/app_styles.dart';

class BasketBottomSheet extends ConsumerWidget {
  const BasketBottomSheet({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Usar el provider global de la cesta
    final basketItems = ref.watch(basketProvider);
    final hasItems = basketItems.isNotEmpty;
    final basketNotifier = ref.read(basketProvider.notifier);
    final totalItems = ref.read(basketProvider.notifier).totalItems;
    final totalPrice = ref.read(basketProvider.notifier).totalPrice;

    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header con botón de cierre y título
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppStyles.paddingMedium,
                vertical: AppStyles.paddingSmall,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Botón de cierre
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),

                  // Título con contador de items
                  Row(
                    children: [
                      Text(
                        'Mi Cesta',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (hasItems) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '$totalItems',
                            style: Theme.of(
                              context,
                            ).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.onPrimary,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),

                  // Espacio para balancear el botón de cierre
                  const SizedBox(width: 48),
                ],
              ),
            ),

            const Divider(),

            // Contenido - Expandido para llenar el espacio
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(AppStyles.paddingMedium),
                child:
                    !hasItems
                        ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.shopping_basket_outlined,
                                size: 64,
                                color: Colors.grey.withOpacity(0.7),
                              ),
                              const SizedBox(height: AppStyles.paddingSmall),
                              Text(
                                'Tu cesta está vacía',
                                style: Theme.of(context).textTheme.titleMedium,
                              ),
                              const SizedBox(height: AppStyles.paddingSmall),
                              Text(
                                'Agrega productos para comenzar tu pedido',
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        )
                        : ListView.builder(
                          itemCount: basketItems.length,
                          itemBuilder: (context, index) {
                            final item = basketItems[index];
                            return _BasketItemTile(
                              productId: item.product.id,
                              imageUrl: item.product.imageUrl,
                              name: item.product.name,
                              price: item.product.price,
                              quantity: item.quantity,
                              onRemove:
                                  () => basketNotifier.removeProduct(
                                    item.product.id,
                                  ),
                              onQuantityChanged:
                                  (newQuantity) =>
                                      basketNotifier.updateQuantity(
                                        item.product.id,
                                        newQuantity,
                                      ),
                            );
                          },
                        ),
              ),
            ),

            // Resumen y botón de checkout (solo visible cuando hay items)
            if (hasItems)
              Padding(
                padding: const EdgeInsets.all(AppStyles.paddingMedium),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Resumen de precio
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Total:',
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        Text(
                          '\$${totalPrice.toStringAsFixed(2)}',
                          style: Theme.of(
                            context,
                          ).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppStyles.paddingMedium),

                    // Botón de checkout
                    ElevatedButton(
                      onPressed: () {
                        // Implementar checkout
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Implementar checkout')),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).colorScheme.primary,
                        foregroundColor:
                            Theme.of(context).colorScheme.onPrimary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                      ),
                      child: const Text('Ir al checkout'),
                    ),
                  ],
                ),
              )
            else
              // Botón de checkout (deshabilitado)
              Padding(
                padding: const EdgeInsets.all(AppStyles.paddingMedium),
                child: ElevatedButton(
                  onPressed:
                      () => Navigator.pushNamed(context, AppRoutes.checkout),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Theme.of(context).colorScheme.primary,
                    foregroundColor: Theme.of(context).colorScheme.onPrimary,
                    disabledBackgroundColor: Colors.grey.withOpacity(0.3),
                    disabledForegroundColor: Colors.grey.withOpacity(0.7),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text('Ir al checkout'),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Widget para mostrar un elemento en la cesta
class _BasketItemTile extends StatelessWidget {
  final String productId;
  final String imageUrl;
  final String name;
  final double price;
  final int quantity;
  final VoidCallback? onRemove;
  final ValueChanged<int>? onQuantityChanged;

  const _BasketItemTile({
    required this.productId,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.quantity,
    this.onRemove,
    this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppStyles.paddingMedium),
      padding: const EdgeInsets.all(AppStyles.paddingSmall),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Imagen del producto
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Image.network(
              imageUrl,
              width: 70,
              height: 70,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  width: 70,
                  height: 70,
                  color: Colors.grey.withOpacity(0.2),
                  child: const Icon(
                    Icons.image_not_supported,
                    color: Colors.grey,
                  ),
                );
              },
            ),
          ),

          const SizedBox(width: AppStyles.paddingSmall),

          // Detalles del producto
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  '\$${(price * quantity).toStringAsFixed(2)}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ),

          // Controles de cantidad
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                onPressed:
                    quantity > 1
                        ? () => onQuantityChanged?.call(quantity - 1)
                        : null,
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(8),
                iconSize: 20,
                color:
                    quantity > 1
                        ? Theme.of(context).colorScheme.primary
                        : Colors.grey,
              ),

              Text(
                '$quantity',
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold),
              ),

              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                onPressed: () => onQuantityChanged?.call(quantity + 1),
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(8),
                iconSize: 20,
                color: Theme.of(context).colorScheme.primary,
              ),

              // Botón de eliminar
              IconButton(
                icon: const Icon(Icons.delete_outline),
                onPressed: onRemove,
                constraints: const BoxConstraints(),
                padding: const EdgeInsets.all(8),
                iconSize: 20,
                color: Colors.red,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
