import 'package:freezed_annotation/freezed_annotation.dart';

part 'basket_item.freezed.dart';
part 'basket_item.g.dart';

/// Represents an item in the user's basket
@freezed
class BasketItem with _$BasketItem {
  const BasketItem._();

  const factory BasketItem({
    required String id,
    required String productId,
    required String name,
    required String imageUrl,
    required double price,
    @Default(1) int quantity,
  }) = _BasketItem;

  /// Total price for this basket item
  double get totalPrice => price * quantity;

  /// Factory constructor to create a BasketItem from JSON
  factory BasketItem.fromJson(Map<String, dynamic> json) =>
      _$BasketItemFromJson(json);
}
