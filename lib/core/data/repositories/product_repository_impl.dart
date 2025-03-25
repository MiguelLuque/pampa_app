import 'package:pampa_app/core/domain/repositories/product_repository.dart';

import '../../domain/models/product.dart';
import 'package:pampa_app/core/constants/image_paths.dart';

class ProductRepositoryImpl implements ProductRepository {
  // Mock data
  final List<Product> _mockProducts = [
    Product(
      id: '1',
      name: 'Alfajores',
      description:
          'Alfajores tradicionales argentinos hechos con dulce de leche entre dos delicadas galletas y recubiertos de azúcar glas. Cada bocado ofrece el equilibrio perfecto entre dulzura y textura.',
      ingredients:
          'Harina de trigo, mantequilla, azúcar, huevos, dulce de leche, maicena, extracto de vainilla, ralladura de limón, azúcar glas.',
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
      description:
          'Deliciosas tartas artesanales elaboradas con ingredientes frescos y naturales. Base crujiente de mantequilla, relleno cremoso y toppings de temporada que despiertan todos los sentidos.',
      ingredients:
          'Harina de trigo seleccionada, mantequilla de calidad premium, huevos de corral, azúcar, frutas frescas de temporada, crema pastelera casera y esencias naturales.',
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
      description:
          'Exquisita bollería argentina elaborada con métodos tradicionales. Nuestras masas fermentadas lentamente aportan un aroma incomparable y una textura esponjosa que se deshace en la boca.',
      ingredients:
          'Harina de trigo de alta calidad, levadura natural, azúcar orgánica, mantequilla francesa, huevos frescos y toques de canela y vainilla para un sabor inigualable.',
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
      description:
          'Galletas artesanales con el equilibrio perfecto entre crujiente exterior y tierno interior. Elaboradas en pequeños lotes para garantizar su frescura y sabor excepcional en cada mordisco.',
      ingredients:
          'Harina de trigo seleccionada, mantequilla premium, azúcar de caña, huevos camperos, vainilla de Madagascar, pizca de sal marina y chips de chocolate belga en algunas variedades.',
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
      description:
          'Granola premium elaborada artesanalmente con la mejor selección de frutos secos y cereales integrales. Tostada lentamente para desarrollar sabores complejos y un irresistible toque crujiente.',
      ingredients:
          'Avena integral de cultivo sostenible, miel de flores silvestres, almendras, nueces de macadamia, arándanos deshidratados, semillas de chía y lino, aceite de coco virgen extra y una pizca de canela de Ceilán.',
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
      description:
          'Auténticas palmeritas de hojaldre hechas a mano con masa de infinitas capas caramelizadas al horno. Su forma de corazón y su dulce crujir las convierten en el acompañante perfecto para tu café o té.',
      ingredients:
          'Hojaldre artesanal elaborado con mantequilla francesa, azúcar caramelizado, pizca de canela de Ceilán y un toque de vainilla natural para realzar los sabores.',
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

  @override
  Future<Product> toggleFavorite(String id, {required bool isFavorite}) async {
    // Simulate network delay
    await Future.delayed(const Duration(milliseconds: 300));

    // Find the product index
    final index = _mockProducts.indexWhere((product) => product.id == id);

    if (index == -1) {
      throw Exception('Product not found');
    }

    // Update the product with the new favorite status
    final updatedProduct = _mockProducts[index].copyWith(
      isFavorite: isFavorite,
    );

    // Update the product in the list
    _mockProducts[index] = updatedProduct;

    return updatedProduct;
  }

  @override
  Future<List<Product>> getFavoriteProducts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockProducts.where((product) => product.isFavorite).toList();
  }
}
