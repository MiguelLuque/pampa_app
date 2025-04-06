import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'basket_provider.g.dart';

/// Provider that manages the basket state
@riverpod
class Basket extends _$Basket {
  @override
  List<String> build() {
    // This is a simplified version - we'll expand this later
    // Currently just returning an empty list as placeholder
    return [];
  }

  /// This is a placeholder method
  /// In the future implementation, it will add a product to the basket
  void addItem(String productId) {
    state = [...state, productId];
  }

  /// This is a placeholder method
  /// In the future implementation, it will remove a product from the basket
  void removeItem(String productId) {
    state = state.where((id) => id != productId).toList();
  }

  /// Returns the number of items in the basket
  int get itemCount => state.length;
}
