# Basket Feature

This feature implements a shopping basket to allow users to add products and proceed to checkout.

## Current Implementation Status

The current implementation provides:

- Basic folder structure for the basket feature
- A bottom sheet that displays when tapping the basket icon
- A placeholder basket provider for state management
- A basket item model (requires code generation)

## Pending Tasks

1. **Code Generation**: Run the following command to generate Freezed/Riverpod models:

   ```
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

2. **Basket Items List**: Implement the list of items in the basket bottom sheet.

3. **Add to Basket Functionality**: Implement functionality to add products to the basket.

4. **Remove from Basket Functionality**: Implement functionality to remove products from the basket.

5. **Persistence**: Add persistence to the basket so items are saved between app sessions.

6. **Checkout Flow**: Implement the checkout flow.

## How to Use

The basket can be accessed from:

1. The shopping bag icon in the bottom navigation bar
2. The shopping cart icon in the product detail screen

The BasketService provides a method `showBasketBottomSheet(context)` that can be called from anywhere in the app to show the basket bottom sheet.
