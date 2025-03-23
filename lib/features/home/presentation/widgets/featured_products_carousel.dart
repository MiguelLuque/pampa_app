import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:async';
import 'package:pampa_app/core/constants/image_paths.dart';
import 'package:pampa_app/core/theme/app_styles.dart';
import 'package:pampa_app/features/home/application/product_provider.dart';
import 'package:pampa_app/features/home/domain/models/product.dart';

class FeaturedProductsCarousel extends HookConsumerWidget {
  const FeaturedProductsCarousel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController();
    final currentPage = useState(0);
    final isUserInteracting = useState(false);

    // Usamos el provider generado automáticamente
    final featuredProductsAsync = ref.watch(featuredProductsProvider);

    // Monitoreo de cambio de página manual
    useEffect(() {
      void listener() {
        final page = pageController.page?.round() ?? 0;
        if (currentPage.value != page) {
          currentPage.value = page;
        }
      }

      pageController.addListener(listener);
      return () => pageController.removeListener(listener);
    }, [pageController]);

    return featuredProductsAsync.when(
      data: (products) {
        if (products.isEmpty) {
          return const SizedBox(
            height: 280,
            child: Center(
              child: Text('No hay productos destacados disponibles'),
            ),
          );
        }

        // Temporizador para cambio automático
        useEffect(() {
          if (products.length <= 1) return null;

          final timer = Timer.periodic(const Duration(seconds: 7), (_) {
            if (!isUserInteracting.value) {
              final nextPage = (currentPage.value + 1) % products.length;
              pageController.animateToPage(
                nextPage,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut,
              );
            }
          });

          return timer.cancel;
        }, [products]);

        return SizedBox(
          height: 280,
          child: Column(
            children: [
              Expanded(
                child: Listener(
                  onPointerDown: (_) => isUserInteracting.value = true,
                  onPointerUp:
                      (_) => Future.delayed(
                        const Duration(seconds: 2),
                        () => isUserInteracting.value = false,
                      ),
                  child: PageView.builder(
                    controller: pageController,
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      final product = products[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppStyles.paddingMedium,
                        ),
                        child: _FeaturedProductItem(
                          imageUrl: product.imageUrl,
                          name: product.name,
                          price: '${product.price}€',
                          isBestSeller: product.isFeatured,
                        ),
                      );
                    },
                  ),
                ),
              ),

              // Indicadores
              const SizedBox(height: AppStyles.spacingMedium),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  products.length,
                  (index) => Container(
                    width: AppStyles.indicatorSize,
                    height: AppStyles.indicatorSize,
                    margin: const EdgeInsets.symmetric(
                      horizontal: AppStyles.spacingTiny,
                    ),
                    decoration: AppStyles.indicatorDecoration(
                      isActive: currentPage.value == index,
                      activeColor: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
      loading:
          () => const SizedBox(
            height: 280,
            child: Center(child: CircularProgressIndicator()),
          ),
      error:
          (error, stackTrace) => SizedBox(
            height: 280,
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
}

class _FeaturedProductItem extends StatelessWidget {
  final String imageUrl;
  final String name;
  final String price;
  final bool isBestSeller;

  const _FeaturedProductItem({
    required this.imageUrl,
    required this.name,
    required this.price,
    required this.isBestSeller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Expanded(
          child: Container(
            margin: const EdgeInsets.only(bottom: AppStyles.paddingSmall),
            decoration: AppStyles.cardDecoration,
            child: Stack(
              children: [
                // Imagen
                ClipRRect(
                  borderRadius: AppStyles.borderRadius,
                  child: CachedNetworkImage(
                    imageUrl: imageUrl,
                    width: double.infinity,
                    height: double.infinity,
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

                // Badge "Más Vendido"
                if (isBestSeller)
                  Positioned(
                    top: AppStyles.paddingSmall,
                    right: AppStyles.paddingSmall,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: AppStyles.badgeDecoration,
                      child: Text('Más Vendido', style: AppStyles.badge),
                    ),
                  ),
              ],
            ),
          ),
        ),
        Text(name, style: AppStyles.titleSmall, textAlign: TextAlign.center),
        const SizedBox(height: AppStyles.spacingTiny),
        Text(price, style: AppStyles.price),
      ],
    );
  }
}
