import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pampa_app/core/data/providers/basket_providers.dart';
import 'package:pampa_app/core/theme/app_styles.dart';
import 'package:pampa_app/features/basket/presentation/services/basket_service.dart';
import 'package:pampa_app/features/home/presentation/widgets/category_section.dart';
import 'package:pampa_app/features/home/presentation/widgets/featured_products_carousel.dart';
import 'package:pampa_app/features/home/presentation/widgets/home_app_bar.dart';
import 'package:pampa_app/features/home/presentation/widgets/main_carousel.dart';
import 'package:pampa_app/features/home/presentation/widgets/product_grid.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basketService = ref.watch(basketServiceProvider);
    final basket = ref.watch(basketProvider);
    final basketItemCount = ref.read(basketProvider.notifier).totalItems;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const HomeAppBar(),
      body: const _HomeContent(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 1) {
            // Carrito tab
            basketService.showBasketBottomSheet(context);
          }
        },
        items: [
          const BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.shopping_bag),
                if (basketItemCount > 0)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.all(2),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 16,
                        minHeight: 16,
                      ),
                      child: Text(
                        '$basketItemCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: 'Carrito',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),
        ],
      ),
    );
  }
}

class _HomeContent extends StatelessWidget {
  const _HomeContent();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Carrusel principal
          const MainCarousel(),

          // Sección de productos destacados
          Padding(
            padding: const EdgeInsets.all(AppStyles.paddingMedium),
            child: Text('Productos Destacados', style: AppStyles.titleMedium),
          ),
          const FeaturedProductsCarousel(),

          // Sección de categorías
          Padding(
            padding: const EdgeInsets.all(AppStyles.paddingMedium),
            child: Text('Categorías', style: AppStyles.titleMedium),
          ),
          const CategorySection(),

          // Sección de productos
          const ProductGrid(),

          const SizedBox(height: AppStyles.spacingMedium),
        ],
      ),
    );
  }
}
