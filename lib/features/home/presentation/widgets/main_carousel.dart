import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'dart:async';
import 'package:pampa_app/core/constants/image_paths.dart';
import 'package:pampa_app/core/theme/app_styles.dart';
import 'package:pampa_app/features/home/application/banner_provider.dart';
import 'package:pampa_app/features/home/domain/models/banner.dart';

class MainCarousel extends HookConsumerWidget {
  const MainCarousel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final pageController = usePageController();
    final currentPage = useState(0);
    final isUserInteracting = useState(false);

    // Usamos el provider generado automáticamente
    final bannersAsync = ref.watch(mainBannersProvider);

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

    // Temporizador para cambio automático
    useEffect(() {
      // Solo configurar el temporizador si tenemos banners
      if (bannersAsync.asData?.value.isEmpty ?? true) return null;

      final timer = Timer.periodic(const Duration(seconds: 5), (_) {
        if (!isUserInteracting.value && bannersAsync.hasValue) {
          final bannerCount = bannersAsync.value!.length;
          if (bannerCount > 1) {
            final nextPage = (currentPage.value + 1) % bannerCount;
            pageController.animateToPage(
              nextPage,
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
            );
          }
        }
      });

      return timer.cancel;
    }, [bannersAsync]);

    return bannersAsync.when(
      data: (banners) {
        if (banners.isEmpty) {
          return const SizedBox(
            height: 240,
            child: Center(child: Text('No hay banners disponibles')),
          );
        }

        return SizedBox(
          height: 240,
          child: Stack(
            children: [
              // Carrusel
              Listener(
                onPointerDown: (_) => isUserInteracting.value = true,
                onPointerUp:
                    (_) => Future.delayed(
                      const Duration(seconds: 2),
                      () => isUserInteracting.value = false,
                    ),
                child: PageView.builder(
                  controller: pageController,
                  itemCount: banners.length,
                  itemBuilder: (context, index) {
                    final banner = banners[index];
                    return _CarouselItem(
                      imageUrl: banner.imageUrl,
                      title: banner.title ?? '',
                      subtitle: banner.description ?? '',
                    );
                  },
                ),
              ),

              // Indicadores
              if (banners.length > 1)
                Positioned(
                  bottom: AppStyles.paddingMedium,
                  left: 0,
                  right: 0,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      banners.length,
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
                ),
            ],
          ),
        );
      },
      loading:
          () => const SizedBox(
            height: 240,
            child: Center(child: CircularProgressIndicator()),
          ),
      error:
          (error, stackTrace) => SizedBox(
            height: 240,
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

class _CarouselItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String subtitle;

  const _CarouselItem({
    required this.imageUrl,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        // Imagen
        CachedNetworkImage(
          imageUrl: imageUrl,
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
                    size: AppStyles.iconSizeLarge,
                  ),
                ),
              ),
        ),

        // Overlay gradiente
        Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.transparent, Colors.black.withOpacity(0.6)],
            ),
          ),
        ),

        // Texto
        Positioned(
          bottom: AppStyles.paddingLarge,
          left: AppStyles.paddingLarge,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: AppStyles.titleLarge),
              const SizedBox(height: AppStyles.spacingTiny),
              Text(subtitle, style: AppStyles.subtitle),
            ],
          ),
        ),
      ],
    );
  }
}
