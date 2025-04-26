import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:pampa_app/core/domain/models/product.dart';

part 'order.freezed.dart';
part 'order.g.dart';

@freezed
class Order with _$Order {
  const factory Order({
    required String id,
    required String userId,
    required String status,
    required DateTime createdAt,
    //añadir si quiere recogida por la mañana o por la tarde siendo esto un enum
    @Default(PickupTime.morning) PickupTime pickupTime,
    DateTime? pickupDateRequested,
    DateTime? pickupDateProposed,
    DateTime? pickupDateConfirmed,
    @Default([]) List<Product> products,
    String? notes,
  }) = _Order;

  factory Order.fromJson(Map<String, dynamic> json) => _$OrderFromJson(json);
}

enum PickupTime { morning, afternoon }
