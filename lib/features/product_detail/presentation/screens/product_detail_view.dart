import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pampa_app/core/domain/models/product.dart';
import 'package:pampa_app/features/product_detail/application/product_detail_provider.dart';
import 'package:pampa_app/features/product_detail/presentation/screens/product_detail_screen.dart';

/// Vista para la pantalla de detalle de producto
///
/// Esta pantalla carga un producto por su ID desde el repositorio y
/// lo muestra en el ProductDetailScreen
class ProductDetailView extends ConsumerWidget {
  const ProductDetailView({super.key, required this.productId});

  /// ID del producto a mostrar
  final String productId;

  /// Nombre de ruta para navegación
  static const routeName = '/product-detail';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Cargamos el producto por su ID
    final productAsync = ref.watch(productByIdProvider(productId));

    return productAsync.when(
      loading:
          () =>
              const Scaffold(body: Center(child: CircularProgressIndicator())),
      error:
          (error, stackTrace) => Scaffold(
            appBar: AppBar(
              title: const Text('Error'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  'Error al cargar el producto: $error',
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ),
      data: (product) {
        if (product == null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('No encontrado'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            body: const Center(child: Text('Producto no encontrado')),
          );
        }

        // Actualizamos el productProvider con el producto cargado
        WidgetsBinding.instance.addPostFrameCallback((_) {
          ref.read(productProvider.notifier).state = product;
        });

        return ProductDetailScreen(product: product);
      },
    );
  }
}

/// Vista de demostración que muestra un producto de ejemplo
///
/// Esta vista es útil para desarrollo y testing
class ProductDetailDemoView extends ConsumerWidget {
  const ProductDetailDemoView({super.key});

  static const routeName = '/product-detail-demo';

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Ejemplo de ID de producto, en una app real esto vendría de la navegación
    const productId = '1'; // ID de los Alfajores

    return ProductDetailView(productId: productId);
  }
}
