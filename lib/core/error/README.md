# Sistema de Gestión de Errores - Pampa App

Este sistema proporciona una forma centralizada de mostrar errores al usuario de manera amigable y consistente en toda la aplicación.

## Características

- Manejo centralizado de errores a través de un Provider
- Categorización de errores por tipo
- Alertas con formato amigable para el usuario
- Animaciones suaves al mostrar y ocultar las alertas
- Cierre automático después de 5 segundos
- Integración automática con los errores de Firebase y otros comunes

## Uso básico

### 1. Reportar un error para mostrar al usuario

```dart
final errorNotifier = ref.read(appErrorProvider.notifier);
errorNotifier.reportError(
  AppError(
    message: 'Mensaje de error para el usuario',
    type: ErrorType.network,
  ),
);
```

### 2. Manejar errores con AsyncValue (recomendado)

```dart
@riverpod
Future<List<Product>> getProducts(GetProductsRef ref) async {
  try {
    return await productRepository.getProducts();
  } catch (e, stack) {
    throw e; // El error se manejará automáticamente
  }
}

// En un widget:
class ProductListScreen extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final products = ref.watch(getProductsProvider);

    // Reporta automáticamente cualquier error al provider de errores
    products.reportErrorIfExists(ref);

    return products.when(
      data: (data) => ProductList(products: data),
      loading: () => const CircularProgressIndicator(),
      error: (_, __) => const Text('No se pudo cargar la información'),
    );
  }
}
```

### 3. Capturar excepciones en código asíncrono

```dart
Future<void> onLoginButtonPressed() async {
  final errorNotifier = ref.read(appErrorProvider.notifier);

  final result = await runCatching(
    action: () => authService.login(email, password),
    errorNotifier: errorNotifier,
  );

  if (result != null) {
    // Login exitoso
    navigateToHome();
  }
  // El error se mostrará automáticamente si ocurre
}
```

## Tipos de errores disponibles

- `ErrorType.network`: Errores de conexión o problemas de red
- `ErrorType.authentication`: Errores relacionados con la autenticación
- `ErrorType.validation`: Errores de validación de datos
- `ErrorType.database`: Errores relacionados con la base de datos
- `ErrorType.firebase`: Errores específicos de Firebase
- `ErrorType.general`: Errores generales no categorizados

## Integración con UI

El sistema ya está integrado en el nivel raíz de la aplicación con `ErrorDisplayWidget`, por lo que todos los errores reportados se mostrarán automáticamente con un banner en la parte inferior de la pantalla.

## Demostración

Para fines de desarrollo y pruebas, puedes usar el módulo de demostración:

```dart
import 'package:pampa_app/core/error/error_demo.dart';

// En cualquier widget con acceso a WidgetRef:
ErrorDemo.showDemoError(ref, ErrorType.network, 'Mensaje personalizado opcional');

// O usa el widget de botones de demostración para probar diferentes tipos de errores:
@override
Widget build(BuildContext context, WidgetRef ref) {
  return Scaffold(
    body: Column(
      children: [
        // Tu contenido normal
        const ErrorDemoButtons(),
      ],
    ),
  );
}
```

## Personalización

Si necesitas personalizar cómo se muestran los errores, puedes modificar:

- `ErrorBanner` para cambiar el aspecto visual
- `AnimatedErrorBanner` para ajustar las animaciones y tiempos de visualización
