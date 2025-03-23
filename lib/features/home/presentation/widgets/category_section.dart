import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pampa_app/core/theme/app_styles.dart';
import 'package:pampa_app/features/home/application/category_provider.dart';
import 'package:pampa_app/features/home/application/product_provider.dart';
import 'package:pampa_app/features/home/domain/models/category.dart';

// Provider para la categoría seleccionada actualmente
final selectedCategoryIdProvider = StateProvider<String>((ref) => 'all');

// Provider para los productos filtrados por categoría
final filteredProductsProvider = Provider<AsyncValue<List<dynamic>>>((ref) {
  final selectedCategoryId = ref.watch(selectedCategoryIdProvider);

  if (selectedCategoryId == 'all') {
    return ref.watch(productsProvider);
  } else {
    return ref.watch(productsByCategoryProvider(selectedCategoryId));
  }
});

class CategorySection extends HookConsumerWidget {
  const CategorySection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategoryId = ref.watch(selectedCategoryIdProvider);
    final categoriesAsync = ref.watch(categoriesProvider);

    return categoriesAsync.when(
      data: (categories) {
        if (categories.isEmpty) {
          return const SizedBox(
            height: 80,
            child: Center(child: Text('No hay categorías disponibles')),
          );
        }

        // Añadimos la categoría "Todos" al inicio
        final allCategories = [
          {'id': 'all', 'name': 'Todos', 'icon': Icons.grid_view},
          ...categories.map(
            (cat) => {
              'id': cat.id,
              'name': cat.name,
              'icon': _getCategoryIcon(cat.name),
            },
          ),
        ];

        return SizedBox(
          height: 80,
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: AppStyles.paddingMedium,
            ),
            child: Row(
              children: List.generate(allCategories.length, (index) {
                final category = allCategories[index] as Map<String, dynamic>;
                final categoryId = category['id'] as String;

                return Padding(
                  padding: const EdgeInsets.only(right: AppStyles.paddingSmall),
                  child: _CategoryItem(
                    icon: category['icon'] as IconData,
                    name: category['name'] as String,
                    count:
                        null, // En una implementación real, podrías obtener la cantidad de productos por categoría
                    isSelected: selectedCategoryId == categoryId,
                    onTap: () {
                      ref.read(selectedCategoryIdProvider.notifier).state =
                          categoryId;
                    },
                  ),
                );
              }),
            ),
          ),
        );
      },
      loading:
          () => const SizedBox(
            height: 80,
            child: Center(child: CircularProgressIndicator()),
          ),
      error:
          (error, stackTrace) => SizedBox(
            height: 80,
            child: Center(
              child: SelectableText.rich(
                TextSpan(
                  children: [
                    const TextSpan(
                      text: 'Error: ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    TextSpan(text: error.toString()),
                  ],
                ),
              ),
            ),
          ),
    );
  }

  // Función para asignar un icono a cada categoría
  IconData _getCategoryIcon(String categoryName) {
    switch (categoryName.toLowerCase()) {
      case 'panadería':
        return Icons.bakery_dining;
      case 'pastelería':
        return Icons.cake;
      case 'desayuno':
        return Icons.breakfast_dining;
      case 'salado':
        return Icons.lunch_dining;
      case 'especialidades':
        return Icons.restaurant;
      default:
        return Icons.category;
    }
  }
}

class _CategoryItem extends StatelessWidget {
  final IconData icon;
  final String name;
  final int? count;
  final bool isSelected;
  final VoidCallback onTap;

  const _CategoryItem({
    required this.icon,
    required this.name,
    required this.count,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    return Column(
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppStyles.paddingMedium,
              vertical: AppStyles.paddingSmall,
            ),
            decoration: BoxDecoration(
              color: isSelected ? primaryColor : Colors.grey[200],
              borderRadius: AppStyles.pillBorderRadius,
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: isSelected ? Colors.white : primaryColor,
                  size: AppStyles.iconSizeSmall,
                ),
                const SizedBox(width: AppStyles.spacingSmall),
                Text(
                  name,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? Colors.white : Colors.black,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (count != null)
          Padding(
            padding: const EdgeInsets.only(top: AppStyles.spacingTiny),
            child: Text(
              '$count productos',
              style: AppStyles.labelSmall.copyWith(
                color: Colors.black.withOpacity(0.6),
              ),
            ),
          ),
      ],
    );
  }
}
