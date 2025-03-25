import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pampa_app/core/router/app_routes.dart';
import 'package:pampa_app/core/theme/app_styles.dart';
import 'package:pampa_app/core/domain/models/product.dart';
import 'package:pampa_app/features/home/presentation/widgets/category_section.dart';

class ProductGrid extends ConsumerWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(filteredProductsProvider);

    // Calcular altura para 2 filas en lugar de 3 para reducir el espacio
    final screenWidth = MediaQuery.of(context).size.width;
    final itemWidth = (screenWidth - (3 * AppStyles.paddingMedium)) / 2;
    final itemHeight = itemWidth / 0.75;
    final minGridHeight = itemHeight * 2; // Solo 2 filas como mínimo

    return Container(
      constraints: BoxConstraints(minHeight: minGridHeight),
      child: productsAsync.when(
        data: (products) {
          if (products.isEmpty) {
            return Container(
              height: minGridHeight,
              padding: const EdgeInsets.symmetric(
                horizontal: AppStyles.paddingLarge,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.bakery_dining_outlined,
                    size: 70,
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.7),
                  ),
                  const SizedBox(height: AppStyles.spacingMedium),
                  Text(
                    '¡Ups! No hay productos disponibles',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppStyles.spacingSmall),
                  Text(
                    'Prueba a seleccionar otra categoría o vuelve más tarde.',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppStyles.paddingMedium,
            ),
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: AppStyles.paddingMedium,
                mainAxisSpacing: AppStyles.paddingMedium,
                childAspectRatio: 0.75,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index] as Product;
                return _ProductCard(
                  productId: product.id,
                  imageUrl: product.imageUrl,
                  name: product.name,
                  price: '${product.price}€',
                );
              },
            ),
          );
        },
        loading:
            () => SizedBox(
              height: minGridHeight,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircularProgressIndicator(),
                    const SizedBox(height: AppStyles.spacingMedium),
                    Text(
                      'Cargando productos...',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ),
        error:
            (error, stackTrace) => SizedBox(
              height: minGridHeight,
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(AppStyles.paddingLarge),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 50,
                        color: Colors.red[400],
                      ),
                      const SizedBox(height: AppStyles.spacingMedium),
                      Text(
                        'Ha ocurrido un error',
                        style: Theme.of(
                          context,
                        ).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Colors.red[700],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: AppStyles.spacingSmall),
                      SelectableText(
                        error.toString(),
                        style: Theme.of(
                          context,
                        ).textTheme.bodySmall?.copyWith(color: Colors.red[400]),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  final String productId;
  final String imageUrl;
  final String name;
  final String price;

  const _ProductCard({
    required this.productId,
    required this.imageUrl,
    required this.name,
    required this.price,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(
          context,
          AppRoutes.productDetail,
          arguments: {'productId': productId},
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: AppStyles.borderRadius),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Imagen del producto
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(16),
                ),
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  width: double.infinity,
                  fit: BoxFit.cover,
                  placeholder:
                      (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                  errorWidget:
                      (context, url, error) => Container(
                        color: Colors.grey[300],
                        child: const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: AppStyles.iconSizeMedium,
                          ),
                        ),
                      ),
                ),
              ),
            ),

            // Información del producto
            Padding(
              padding: const EdgeInsets.all(AppStyles.paddingSmall),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(name, style: AppStyles.titleSmall),
                  const SizedBox(height: AppStyles.spacingTiny),
                  Text(price, style: AppStyles.price),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
