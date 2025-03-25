import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../core/data/repositories/category_repository_impl.dart';
import '../../../core/domain/models/category.dart';
import '../../../core/domain/repositories/category_repository.dart';

part 'category_provider.g.dart';

@riverpod
CategoryRepository categoryRepository(CategoryRepositoryRef ref) {
  return CategoryRepositoryImpl();
}

@riverpod
Future<List<Category>> categories(CategoriesRef ref) {
  final repository = ref.watch(categoryRepositoryProvider);
  return repository.getCategories();
}

@riverpod
Future<Category?> category(CategoryRef ref, String id) {
  final repository = ref.watch(categoryRepositoryProvider);
  return repository.getCategoryById(id);
}
