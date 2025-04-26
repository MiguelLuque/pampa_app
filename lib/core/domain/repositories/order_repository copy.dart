import 'package:pampa_app/core/domain/models/order.dart';

abstract class OrderRepository {
  /// Obtiene un producto por su ID
  Future<Order?> getOrderById(String id);

  Future<List<Order>> getOrders();

  //crear un pedido
  Future<Order> createOrder(Order order);
}
