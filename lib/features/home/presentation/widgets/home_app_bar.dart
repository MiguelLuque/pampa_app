import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:pampa_app/core/constants/image_paths.dart';
import 'package:pampa_app/core/theme/app_styles.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Theme.of(context).colorScheme.primary,
      title: Row(
        children: [
          // Logo de Pampa
          CachedNetworkImage(
            imageUrl: ImagePaths.logoPath,
            height: 40,
            placeholder:
                (context, url) => const SizedBox(
                  width: 40,
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  ),
                ),
            errorWidget:
                (context, url, error) =>
                    const Icon(Icons.image_not_supported, color: Colors.white),
          ),
          const SizedBox(width: AppStyles.paddingSmall),
          Text(
            'Panadería Artesanal Argentina',
            style: AppStyles.bodyMedium.copyWith(color: Colors.white),
          ),
        ],
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.search, color: Colors.white),
          onPressed: () {
            // TODO: Implementar búsqueda
          },
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
