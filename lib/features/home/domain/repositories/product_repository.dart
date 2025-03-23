import '../models/product.dart';

abstract class ProductRepository {
  Future<List<Product>> getProducts();
  Future<List<Product>> getFeaturedProducts();
  Future<Product?> getProductById(String id);
  Future<List<Product>> getProductsByCategory(String categoryId);
}
