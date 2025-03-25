import 'package:pampa_app/core/domain/repositories/product_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/data/repositories/product_repository_impl.dart';
import '../../../core/domain/models/product.dart';

part 'product_provider.g.dart';

@riverpod
ProductRepository productRepository(ProductRepositoryRef ref) {
  return ProductRepositoryImpl();
}

@riverpod
Future<List<Product>> products(ProductsRef ref) {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProducts();
}

@riverpod
Future<List<Product>> featuredProducts(FeaturedProductsRef ref) {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getFeaturedProducts();
}

@riverpod
Future<List<Product>> productsByCategory(
  ProductsByCategoryRef ref,
  String categoryId,
) {
  final repository = ref.watch(productRepositoryProvider);
  return repository.getProductsByCategory(categoryId);
}

@riverpod
Future<Product> product(ProductRef ref, String id) async {
  final repository = ref.watch(productRepositoryProvider);
  final product = await repository.getProductById(id);
  if (product == null) {
    throw Exception('Product not found');
  }
  return product;
}
