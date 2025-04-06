import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pampa_app/core/data/providers/basket_providers.dart';
import 'package:pampa_app/core/data/providers/repository_providers.dart';
import 'package:pampa_app/core/domain/models/product.dart';

part 'product_detail_provider.g.dart';

// Provider for current quantity
@riverpod
class Quantity extends _$Quantity {
  @override
  int build() => 1;
}

// Provider for loading a product by ID
@riverpod
Future<Product?> productById(ProductByIdRef ref, String id) async {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProductById(id);
}

// Provider for the product currently being viewed
@riverpod
class ProductDetail extends _$ProductDetail {
  @override
  Product? build() => null;
}

// Provider for adding to cart
@riverpod
void addToCart(AddToCartRef ref) {
  final product = ref.read(productDetailProvider);
  final quantity = ref.read(quantityProvider);

  if (product != null) {
    // Añadir el producto a la cesta global
    ref.read(basketProvider.notifier).addProduct(product, quantity: quantity);

    // Mostrar mensaje (opcional)
    print('Added ${quantity}x ${product.name} to cart');
  }
}
