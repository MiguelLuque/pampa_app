import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pampa_app/core/domain/models/product.dart';
import 'package:pampa_app/core/theme/app_styles.dart';
import 'package:pampa_app/features/product_detail/application/product_detail_provider.dart';
import 'package:pampa_app/features/product_detail/presentation/widgets/quantity_selector.dart';

class ProductDetailScreen extends ConsumerWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    // Watch product changes (for favorite status)
    final currentProduct = ref.watch(productProvider) ?? product;
    final quantity = ref.watch(quantityProvider);

    // Get action functions from providers
    final toggleFavorite = ref.read(productFavoriteProvider);
    final addToCart = ref.read(addToCartProvider);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        title: const Text('Detalles del Producto'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              // Navegar al carrito
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Carrito no implementado aún'),
                  duration: Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image with Favorite Icon
                  Stack(
                    children: [
                      // Image
                      currentProduct.imageUrl.isNotEmpty
                          ? Image.network(
                            currentProduct.imageUrl,
                            width: double.infinity,
                            height: 250,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Image.asset(
                                'assets/images/placeholder.png',
                                width: double.infinity,
                                height: 250,
                                fit: BoxFit.cover,
                              );
                            },
                          )
                          : Image.asset(
                            'assets/images/placeholder.png',
                            width: double.infinity,
                            height: 250,
                            fit: BoxFit.cover,
                          ),

                      // Favorite Icon
                      Positioned(
                        top: 8,
                        right: 8,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.8),
                            shape: BoxShape.circle,
                          ),
                          child: IconButton(
                            icon: Icon(
                              currentProduct.isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: theme.colorScheme.primary,
                            ),
                            onPressed: toggleFavorite,
                          ),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Title and Price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                currentProduct.name,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              '€${currentProduct.price.toStringAsFixed(2)}',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Description Section
                        Text(
                          'Descripción',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentProduct.description,
                          style: theme.textTheme.bodyMedium,
                        ),

                        const SizedBox(height: 16),

                        // Ingredients Section
                        Text(
                          'Ingredientes',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentProduct.ingredients,
                          style: theme.textTheme.bodyMedium,
                        ),

                        const SizedBox(height: 24),

                        // Quantity Selector - Larger Buttons
                        Row(
                          children: [
                            Text(
                              'Cantidad',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              height: 48, // Mayor altura para los botones
                              child: QuantitySelector(
                                initialValue: quantity,
                                onChanged: (value) {
                                  ref.read(quantityProvider.notifier).state =
                                      value;
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Add to Cart Button at the bottom
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  minimumSize: const Size(
                    double.infinity,
                    56,
                  ), // Botón más alto
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: addToCart,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_cart, size: 24),
                    const SizedBox(width: 10),
                    Text(
                      'Añadir a la Cesta - €${(currentProduct.price * quantity).toStringAsFixed(2)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: 16, // Texto más grande
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
