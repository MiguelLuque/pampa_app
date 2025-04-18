import 'package:pampa_app/core/domain/repositories/product_repository.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/models/product.dart';
import 'package:pampa_app/core/constants/image_paths.dart';

class ProductRepositoryImpl implements ProductRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final String _collection = 'products';

  // Mock data kept for reference or fallback
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

  // Helper method to convert Firestore documents to Product objects
  Product _productFromSnapshot(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    return Product.fromJson({
      'id': doc.id,
      ...data,
      'createdAt': data['createdAt']?.toDate().toString(),
      'updatedAt': data['updatedAt']?.toDate().toString(),
    });
  }

  @override
  Future<List<Product>> getProducts() async {
    try {
      final snapshot =
          await _firestore
              .collection(_collection)
              .where('isDeleted', isEqualTo: false)
              .get();
      var products =
          snapshot.docs.map((doc) => _productFromSnapshot(doc)).toList();
      return products;
    } catch (e) {
      // Fallback to mock data in case of error
      return [];
    }
  }

  @override
  Future<List<Product>> getFeaturedProducts() async {
    try {
      final snapshot =
          await _firestore
              .collection(_collection)
              .where('isFeatured', isEqualTo: true)
              .where('isDeleted', isEqualTo: false)
              .get();

      var products =
          snapshot.docs.map((doc) => _productFromSnapshot(doc)).toList();
      return products;
    } catch (e) {
      //imprime el error
      print(e);
      // Fallback to mock data in case of error
      return _mockProducts.where((product) => product.isFeatured).toList();
    }
  }

  @override
  Future<Product?> getProductById(String id) async {
    try {
      final doc = await _firestore.collection(_collection).doc(id).get();

      if (!doc.exists) {
        throw Exception('Product not found');
      }

      return _productFromSnapshot(doc);
    } catch (e) {
      // Fallback to mock data
      try {
        return _mockProducts.firstWhere(
          (product) => product.id == id,
          orElse: () => throw Exception('Product not found'),
        );
      } catch (e) {
        rethrow;
      }
    }
  }

  @override
  Future<List<Product>> getProductsByCategory(String categoryId) async {
    try {
      final snapshot =
          await _firestore
              .collection(_collection)
              .where('category', isEqualTo: categoryId)
              .where('isDeleted', isEqualTo: false)
              .get();

      var products =
          snapshot.docs.map((doc) => _productFromSnapshot(doc)).toList();
      return products;
    } catch (e) {
      // Fallback to mock data
      return _mockProducts
          .where((product) => product.category == categoryId)
          .toList();
    }
  }

  @override
  Future<Product> toggleFavorite(String id, {required bool isFavorite}) async {
    try {
      // Get the product to update
      final doc = await _firestore.collection(_collection).doc(id).get();

      if (!doc.exists) {
        throw Exception('Product not found');
      }

      // Update the favorite status
      await _firestore.collection(_collection).doc(id).update({
        'isFavorite': isFavorite,
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // Get the updated product
      final updatedDoc = await _firestore.collection(_collection).doc(id).get();
      return _productFromSnapshot(updatedDoc);
    } catch (e) {
      // Fallback to mock data
      final index = _mockProducts.indexWhere((product) => product.id == id);

      if (index == -1) {
        throw Exception('Product not found');
      }

      final updatedProduct = _mockProducts[index].copyWith(
        isFavorite: isFavorite,
      );

      _mockProducts[index] = updatedProduct;

      return updatedProduct;
    }
  }

  @override
  Future<List<Product>> getFavoriteProducts() async {
    try {
      final snapshot =
          await _firestore
              .collection(_collection)
              .where('isFavorite', isEqualTo: true)
              .where('isDeleted', isEqualTo: false)
              .get();

      return snapshot.docs.map((doc) => _productFromSnapshot(doc)).toList();
    } catch (e) {
      // Fallback to mock data
      return _mockProducts.where((product) => product.isFavorite).toList();
    }
  }
}
