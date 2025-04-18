import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pampa_app/core/data/providers/basket_providers.dart';
import 'package:pampa_app/core/router/app_routes.dart';
import 'package:pampa_app/core/theme/app_styles.dart';
import 'package:pampa_app/features/auth/application/auth_provider.dart';
import 'package:pampa_app/features/basket/presentation/services/basket_service.dart';
import 'package:pampa_app/features/home/presentation/widgets/category_section.dart';
import 'package:pampa_app/features/home/presentation/widgets/featured_products_carousel.dart';
import 'package:pampa_app/features/home/presentation/widgets/home_app_bar.dart';
import 'package:pampa_app/features/home/presentation/widgets/logout_dialog.dart';
import 'package:pampa_app/features/home/presentation/widgets/main_carousel.dart';
import 'package:pampa_app/features/home/presentation/widgets/product_grid.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final basketService = ref.watch(basketServiceProvider);
    final basket = ref.watch(basketProvider);
    final basketItemCount = ref.read(basketProvider.notifier).totalItems;
    final authState = ref.watch(authStateProvider);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: const HomeAppBar(),
      body: const _HomeContent(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        onTap: (index) async {
          // El índice real depende de si el usuario está autenticado y si se muestra el botón de pedidos
          final bool userLoggedIn = authState.value != null;
          final int loginLogoutIndex = userLoggedIn ? 3 : 2;

          if (index == 1) {
            // Carrito tab
            basketService.showBasketBottomSheet(context);
          } else if (userLoggedIn && index == 2) {
            // Pedidos tab - solo visible si está autenticado
            Navigator.of(context).pushNamed('/orders');
          } else if (index == loginLogoutIndex) {
            // Login/Logout tab
            if (!userLoggedIn && context.mounted) {
              // Si no está autenticado, llevarlo a la pantalla de login
              Navigator.of(context).pushNamed(AppRoutes.login);
            } else if (context.mounted) {
              // Mostrar diálogo de logout si está autenticado
              showDialog(
                context: context,
                builder: (context) => const LogoutDialog(),
              );
            }
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
            label: 'Cesta',
          ),
          if (authState.value != null)
            const BottomNavigationBarItem(
              icon: Icon(Icons.list_alt),
              label: 'Pedidos',
            ),
          // Mostrar icono diferente según estado de autenticación
          BottomNavigationBarItem(
            icon: authState.maybeWhen(
              data:
                  (authUser) =>
                      Icon(authUser != null ? Icons.logout : Icons.person),
              orElse: () => const Icon(Icons.person),
            ),
            label: authState.maybeWhen(
              data: (authUser) => authUser != null ? 'Cerrar sesión' : 'Login',
              orElse: () => 'Login',
            ),
          ),

          // Pedidos tab - solo visible si está autenticado
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
