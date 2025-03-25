import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pampa_app/core/data/providers/repository_providers.dart';
import 'package:pampa_app/core/domain/models/product.dart';

// Provider for current quantity
final quantityProvider = StateProvider.autoDispose<int>((ref) => 1);

// Provider para el número de productos en el carrito
final cartItemCountProvider = StateProvider<int>((ref) => 0);

// Provider for loading a product by ID
final productByIdProvider = FutureProvider.autoDispose.family<Product?, String>(
  (ref, id) async {
    final repository = ref.watch(productRepositoryProvider);
    return repository.getProductById(id);
  },
);

// Provider for the product currently being viewed
final productProvider = StateProvider.autoDispose<Product?>((ref) => null);

// Provider for toggling favorite status
final productFavoriteProvider = Provider.autoDispose<void Function()>((ref) {
  return () async {
    final product = ref.read(productProvider);
    if (product != null) {
      final repository = ref.read(productRepositoryProvider);

      try {
        // Toggle the favorite status using the repository
        final updatedProduct = await repository.toggleFavorite(
          product.id,
          isFavorite: !product.isFavorite,
        );

        // Update the product in the provider
        ref.read(productProvider.notifier).update((_) => updatedProduct);
      } catch (e) {
        // Manejar error
        print('Error al cambiar favorito: $e');
      }
    }
  };
});

// Provider for adding to cart
final addToCartProvider = Provider.autoDispose<void Function()>((ref) {
  return () {
    final product = ref.read(productProvider);
    final quantity = ref.read(quantityProvider);

    if (product != null) {
      // Incrementar el contador del carrito
      ref
          .read(cartItemCountProvider.notifier)
          .update((state) => state + quantity);

      // En una implementación real, aquí se añadiría a un repositorio de carrito
      print('Added ${quantity}x ${product.name} to cart');
    }
  };
});
