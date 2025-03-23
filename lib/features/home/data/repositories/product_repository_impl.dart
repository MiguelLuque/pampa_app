import '../../domain/models/product.dart';
import '../../domain/repositories/product_repository.dart';
import 'package:pampa_app/core/constants/image_paths.dart';

class ProductRepositoryImpl implements ProductRepository {
  // Mock data
  final List<Product> _mockProducts = [
    Product(
      id: '1',
      name: 'Alfajores Clásicos',
      description: 'Alfajores tradicionales con dulce de leche y coco rallado',
      price: 4.50,
      imageUrl: ImagePaths.alfajoresPath,
      isFeatured: true,
      stock: 25,
      category: '1',
      tags: ['dulces', 'tradicionales', 'alfajores'],
    ),
    Product(
      id: '2',
      name: 'Tartas',
      description: 'Tartas caseras para cualquier ocasión',
      price: 5.95,
      imageUrl: ImagePaths.tartasPath,
      isFeatured: true,
      stock: 30,
      category: '2',
      tags: ['tartas', 'dulces', 'postres'],
    ),
    Product(
      id: '3',
      name: 'Bollería',
      description: 'Bollería tradicional argentina',
      price: 2.75,
      imageUrl: ImagePaths.bolleriaPath,
      isFeatured: true,
      stock: 50,
      category: '1',
      tags: ['bollería', 'tradicional', 'panadería'],
    ),
    Product(
      id: '4',
      name: 'Galletas',
      description: 'Galletas caseras artesanales',
      price: 3.25,
      imageUrl: ImagePaths.galletasPath,
      isFeatured: false,
      stock: 40,
      category: '3',
      tags: ['galletas', 'dulces'],
    ),
    Product(
      id: '5',
      name: 'Granola',
      description: 'Granola casera con frutos secos',
      price: 5.75,
      imageUrl: ImagePaths.granolaPath,
      isFeatured: false,
      stock: 20,
      category: '3',
      tags: ['granola', 'desayuno', 'saludable'],
    ),
    Product(
      id: '6',
      name: 'Palmeritas',
      description: 'Palmeritas de hojaldre caseras',
      price: 3.50,
      imageUrl: ImagePaths.palmeritasPath,
      isFeatured: true,
      stock: 15,
      category: '1',
      tags: ['dulces', 'hojaldre', 'tradicional'],
    ),
  ];

  @override
  Future<List<Product>> getProducts() async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 800));
    return _mockProducts;
  }

  @override
  Future<List<Product>> getFeaturedProducts() async {
    await Future.delayed(const Duration(milliseconds: 600));
    return _mockProducts.where((product) => product.isFeatured).toList();
  }

  @override
  Future<Product?> getProductById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return _mockProducts.firstWhere(
      (product) => product.id == id,
      orElse: () => throw Exception('Product not found'),
    );
  }

  @override
  Future<List<Product>> getProductsByCategory(String categoryId) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockProducts
        .where((product) => product.category == categoryId)
        .toList();
  }
}
