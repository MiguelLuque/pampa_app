import '../../domain/models/category.dart';
import '../../domain/repositories/category_repository.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  // Mock data
  final List<Category> _mockCategories = [
    Category(
      id: '1',
      name: 'Panadería',
      imageUrl: 'https://via.placeholder.com/150x150?text=Panaderia',
      description: 'Productos de panadería tradicional argentina',
    ),
    Category(
      id: '2',
      name: 'Pastelería',
      imageUrl: 'https://via.placeholder.com/150x150?text=Pasteleria',
      description: 'Productos dulces y tartas',
    ),
    Category(
      id: '3',
      name: 'Desayuno',
      imageUrl: 'https://via.placeholder.com/150x150?text=Desayuno',
      description: 'Productos para el desayuno',
    ),
    Category(
      id: '4',
      name: 'Salado',
      imageUrl: 'https://via.placeholder.com/150x150?text=Salado',
      description: 'Productos salados',
    ),
    Category(
      id: '5',
      name: 'Especialidades',
      imageUrl: 'https://via.placeholder.com/150x150?text=Especialidades',
      description: 'Especialidades argentinas',
    ),
  ];

  @override
  Future<List<Category>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _mockCategories;
  }

  @override
  Future<Category?> getCategoryById(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    try {
      return _mockCategories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }
}
