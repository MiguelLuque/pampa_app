import 'package:pampa_app/core/domain/models/product.dart';

/// Interface para el repositorio de productos
///
/// Esta interface define los métodos que debe implementar un repositorio
/// de productos, independientemente de la fuente de datos utilizada.
abstract class ProductRepository {
  /// Obtiene un producto por su ID
  Future<Product?> getProductById(String id);

  Future<List<Product>> getFeaturedProducts();

  /// Obtiene una lista de productos
  Future<List<Product>> getProducts();

  /// Obtiene una lista de productos favoritos
  Future<List<Product>> getFavoriteProducts();

  /// Marca o desmarca un producto como favorito
  Future<Product> toggleFavorite(String id, {required bool isFavorite});

  Future<List<Product>> getProductsByCategory(String categoryId);
}
