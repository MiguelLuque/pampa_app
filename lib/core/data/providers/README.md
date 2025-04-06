# Providers con Generación de Código

Este directorio contiene providers que utilizan la forma moderna de Riverpod con generación de código a través de anotaciones.

## Importante: Generación de Código

Después de modificar o crear providers con anotaciones como `@riverpod` o `@Riverpod`, debes ejecutar el siguiente comando para generar los archivos necesarios:

```bash
flutter pub run build_runner build --delete-conflicting-outputs
```

## Providers Implementados

- **basket_providers.dart**: Gestiona el estado global de la cesta de compras
  - `basketProvider`: Lista de productos en la cesta con sus cantidades
  - `basketItemCountProvider`: Número total de items en la cesta
  - `basketTotalPriceProvider`: Precio total de la cesta

## Cómo usar estos Providers

1. Para leer el estado:

```dart
// En un widget
final basketItems = ref.watch(basketProvider);
final itemCount = ref.watch(basketItemCountProvider);
final totalPrice = ref.watch(basketTotalPriceProvider);
```

2. Para modificar el estado:

```dart
// Añadir producto
ref.read(basketProvider.notifier).addProduct(product, quantity: 2);

// Eliminar producto
ref.read(basketProvider.notifier).removeProduct(productId);

// Actualizar cantidad
ref.read(basketProvider.notifier).updateQuantity(productId, 3);

// Vaciar la cesta
ref.read(basketProvider.notifier).clearBasket();
```

## Notas

- Todos los providers marcados con `@Riverpod(keepAlive: true)` mantendrán su estado durante toda la vida de la aplicación.
- Los providers marcados solo con `@riverpod` se destruirán cuando no tengan observadores.
- Para más información, consulta la [documentación oficial de Riverpod](https://riverpod.dev/docs/concepts/providers/).
