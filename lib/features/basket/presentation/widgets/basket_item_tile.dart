import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pampa_app/core/theme/app_styles.dart';

/// A widget that displays a basket item
class BasketItemTile extends ConsumerWidget {
  final String productId;
  final String imageUrl;
  final String name;
  final double price;
  final int quantity;
  final VoidCallback? onRemove;
  final ValueChanged<int>? onQuantityChanged;

  const BasketItemTile({
    super.key,
    required this.productId,
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.quantity,
    this.onRemove,
    this.onQuantityChanged,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
          // Product image
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

          // Product details
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

          // Quantity controls
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

              // Remove button
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
