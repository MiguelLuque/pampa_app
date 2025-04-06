import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pampa_app/core/domain/models/product.dart';

// Esto permitirá generar el código
part 'basket_providers.g.dart';

/// Modelo para cada item en la cesta que contiene un producto y su cantidad
class BasketItem {
  final Product product;
  final int quantity;

  const BasketItem({required this.product, required this.quantity});

  /// Calcula el precio total para este item (precio × cantidad)
  double get totalPrice => product.price * quantity;
}

/// Provider para la cesta de compras global usando la sintaxis moderna
@Riverpod(keepAlive: true)
class Basket extends _$Basket {
  @override
  List<BasketItem> build() {
    return [];
  }

  /// Añade un producto a la cesta o incrementa su cantidad si ya existe
  void addProduct(Product product, {int quantity = 1}) {
    // Buscar si el producto ya está en la cesta
    final index = state.indexWhere((item) => item.product.id == product.id);

    if (index >= 0) {
      // El producto ya está en la cesta, actualizar cantidad
      final currentItem = state[index];
      final newQuantity = currentItem.quantity + quantity;
      final updatedItem = BasketItem(product: product, quantity: newQuantity);

      // Crear una nueva lista con el elemento actualizado
      state = [
        ...state.sublist(0, index),
        updatedItem,
        ...state.sublist(index + 1),
      ];
    } else {
      // El producto no está en la cesta, añadirlo
      state = [...state, BasketItem(product: product, quantity: quantity)];
    }
  }

  /// Elimina un producto de la cesta
  void removeProduct(String productId) {
    state = state.where((item) => item.product.id != productId).toList();
  }

  /// Actualiza la cantidad de un producto en la cesta
  void updateQuantity(String productId, int quantity) {
    if (quantity <= 0) {
      removeProduct(productId);
      return;
    }

    final index = state.indexWhere((item) => item.product.id == productId);
    if (index >= 0) {
      final item = state[index];
      final updatedItem = BasketItem(product: item.product, quantity: quantity);

      state = [
        ...state.sublist(0, index),
        updatedItem,
        ...state.sublist(index + 1),
      ];
    }
  }

  /// Vacía la cesta
  void clearBasket() {
    state = [];
  }

  /// Obtiene el número total de productos en la cesta (suma de cantidades)
  int get totalItems {
    return state.fold(0, (sum, item) => sum + item.quantity);
  }

  /// Calcula el precio total de la cesta
  double get totalPrice {
    return state.fold(0.0, (sum, item) => sum + item.totalPrice);
  }
}
