import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pampa_app/core/data/repositories/product_repository_impl.dart';
import 'package:pampa_app/core/domain/repositories/product_repository.dart';

/// Provider para el repositorio de productos
final productRepositoryProvider = Provider<ProductRepository>((ref) {
  // Por ahora usamos la implementación mock
  // En el futuro esto podría cambiar a una implementación real
  return ProductRepositoryImpl();
});
