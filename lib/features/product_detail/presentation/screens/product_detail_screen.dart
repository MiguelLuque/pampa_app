import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pampa_app/core/data/providers/basket_providers.dart';
import 'package:pampa_app/core/domain/models/product.dart';
import 'package:pampa_app/features/basket/presentation/services/basket_service.dart';
import 'package:pampa_app/features/product_detail/application/product_detail_provider.dart';
import 'package:pampa_app/features/product_detail/presentation/widgets/quantity_selector.dart';

class ProductDetailScreen extends ConsumerStatefulWidget {
  const ProductDetailScreen({super.key, required this.product});

  final Product product;

  @override
  ConsumerState<ProductDetailScreen> createState() =>
      _ProductDetailScreenState();
}

class _ProductDetailScreenState extends ConsumerState<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  // Referencia al botón del carrito para obtener su posición
  final GlobalKey _cartIconKey = GlobalKey();
  // Referencia al botón de añadir a la cesta para obtener su posición
  final GlobalKey _addToCartButtonKey = GlobalKey();

  late AnimationController _animationController;
  late Animation<double> _positionAnimation;
  late Animation<double> _sizeAnimation;
  late Animation<double> _opacityAnimation;

  OverlayEntry? _overlayEntry;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 850),
      vsync: this,
    );

    _positionAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _sizeAnimation = Tween<double>(begin: 1.0, end: 0.3).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 1.0, end: 0.7).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
      ),
    );

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _overlayEntry?.remove();
        _overlayEntry = null;
        _animationController.reset();
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Set current product in the provider - moved from build method
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(productDetailProvider.notifier).state = widget.product;
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  // Obtiene la posición de un widget en la pantalla
  Offset _getWidgetPosition(GlobalKey key) {
    final RenderBox renderBox =
        key.currentContext?.findRenderObject() as RenderBox;
    final position = renderBox.localToGlobal(Offset.zero);
    return position;
  }

  // Obtiene el tamaño de un widget
  Size _getWidgetSize(GlobalKey key) {
    final RenderBox renderBox =
        key.currentContext?.findRenderObject() as RenderBox;
    return renderBox.size;
  }

  // Inicia la animación de añadir al carrito
  void _startAddToCartAnimation(String imageUrl) {
    // Obtener posiciones
    final startPosition = _getWidgetPosition(_addToCartButtonKey);
    final startSize = _getWidgetSize(_addToCartButtonKey);
    final endPosition = _getWidgetPosition(_cartIconKey);

    // Calcular la curva de la animación (trayectoria)
    final startX = startPosition.dx + startSize.width / 2;
    final startY = startPosition.dy + 20;
    final endX = endPosition.dx;
    final endY = endPosition.dy;

    // Crear un punto de control para la trayectoria curva
    final controlX = (startX + endX) / 2;
    final controlY = startY - 100; // Ajustar para una curva más pronunciada

    // Crear y mostrar el overlay para la animación
    _overlayEntry = OverlayEntry(
      builder: (context) {
        return AnimatedBuilder(
          animation: _positionAnimation,
          builder: (context, child) {
            // Calcular la posición en cada frame
            final t = _positionAnimation.value;
            final double x = _calculateBezierPoint(t, startX, controlX, endX);
            final double y = _calculateBezierPoint(t, startY, controlY, endY);

            return Positioned(
              left: x - 20 * _sizeAnimation.value,
              top: y - 20 * _sizeAnimation.value,
              child: Opacity(
                opacity: _opacityAnimation.value,
                child: Transform.scale(
                  scale: _sizeAnimation.value,
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Center(
                      child:
                          imageUrl.isNotEmpty
                              ? ClipOval(
                                child: Image.network(
                                  imageUrl,
                                  width: 30,
                                  height: 30,
                                  fit: BoxFit.cover,
                                  errorBuilder:
                                      (context, error, stackTrace) =>
                                          const Icon(
                                            Icons.shopping_cart,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                ),
                              )
                              : const Icon(
                                Icons.shopping_cart,
                                color: Colors.white,
                                size: 20,
                              ),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
    _animationController.forward();
  }

  // Calcula un punto en una curva de Bezier cuadrática
  double _calculateBezierPoint(
    double t,
    double start,
    double control,
    double end,
  ) {
    return (1 - t) * (1 - t) * start + 2 * (1 - t) * t * control + t * t * end;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Watch product changes
    final currentProduct = widget.product;
    final quantity = ref.watch(quantityProvider);
    final basket = ref.watch(basketProvider);
    final basketItemCount = basket.fold(0, (sum, item) => sum + item.quantity);

    // Función que combina añadir al carrito con iniciar la animación
    void handleAddToCart() {
      // Asegurarnos que el producto actual está en el provider
      ref.read(productDetailProvider.notifier).state = currentProduct;

      // Ejecutar la lógica de negocio para añadir al carrito
      // Accedemos directamente al basketProvider para añadir el producto
      ref
          .read(basketProvider.notifier)
          .addProduct(currentProduct, quantity: quantity);

      // Mostrar mensaje (opcional)
      print('Added ${quantity}x ${currentProduct.name} to cart');

      // Luego iniciar la animación
      //_startAddToCartAnimation(currentProduct.imageUrl);
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
        title: const Text('Detalles del Producto'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          Stack(
            alignment: Alignment.center,
            children: [
              IconButton(
                key: _cartIconKey,
                icon: const Icon(Icons.shopping_bag),
                onPressed: () {
                  // Use BasketService to show basket bottom sheet
                  ref
                      .read(basketServiceProvider)
                      .showBasketBottomSheet(context);
                },
              ),
              if (basketItemCount > 0)
                Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      '$basketItemCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Product Image
                  currentProduct.imageUrl.isNotEmpty
                      ? Image.network(
                        currentProduct.imageUrl,
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            'assets/images/placeholder.png',
                            width: double.infinity,
                            height: 250,
                            fit: BoxFit.cover,
                          );
                        },
                      )
                      : Image.asset(
                        'assets/images/placeholder.png',
                        width: double.infinity,
                        height: 250,
                        fit: BoxFit.cover,
                      ),

                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Product Title and Price
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child: Text(
                                currentProduct.name,
                                style: theme.textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              '€${currentProduct.price.toStringAsFixed(2)}',
                              style: theme.textTheme.titleLarge?.copyWith(
                                color: theme.colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // Description Section
                        Text(
                          'Descripción',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentProduct.description,
                          style: theme.textTheme.bodyMedium,
                        ),

                        const SizedBox(height: 16),

                        // Ingredients Section
                        Text(
                          'Ingredientes',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          currentProduct.ingredients,
                          style: theme.textTheme.bodyMedium,
                        ),

                        const SizedBox(height: 24),

                        // Quantity Selector - Larger Buttons
                        Row(
                          children: [
                            Text(
                              'Cantidad',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const Spacer(),
                            SizedBox(
                              height: 48, // Mayor altura para los botones
                              child: QuantitySelector(
                                initialValue: quantity,
                                onChanged: (value) {
                                  ref.read(quantityProvider.notifier).state =
                                      value;
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Add to Cart Button at the bottom
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                key: _addToCartButtonKey,
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.colorScheme.primary,
                  foregroundColor: theme.colorScheme.onPrimary,
                  minimumSize: const Size(
                    double.infinity,
                    56,
                  ), // Botón más alto
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: handleAddToCart,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.shopping_cart, size: 24),
                    const SizedBox(width: 10),
                    Text(
                      'Añadir a la Cesta - €${(currentProduct.price * quantity).toStringAsFixed(2)}',
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onPrimary,
                        fontWeight: FontWeight.w500,
                        fontSize: 16, // Texto más grande
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
