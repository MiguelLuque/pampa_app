import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:pampa_app/core/domain/models/order.dart';
import 'package:pampa_app/features/checkout/domain/order_creation_state.dart';

final checkoutProvider = StateNotifierProvider<CheckoutNotifier, Order>(
  (ref) => CheckoutNotifier(),
);

class CheckoutNotifier extends StateNotifier<Order> {
  CheckoutNotifier() : super(const Order());

  // Update the pickup date
  void updatePickupDate(DateTime date) {
    state = state.copyWith(pickupDate: date);
  }

  // Update the pickup time (morning/afternoon)
  void updatePickupTime(PickupTime time) {
    state = state.copyWith(pickupTime: time);
  }

  // Update order notes
  void updateNotes(String notes) {
    state = state.copyWith(notes: notes);
  }

  // Calculate order total based on products in the basket
  void calculateTotal(List<dynamic> basketItems) {
    // This would be implemented to calculate the subtotal based on products
    // For the skeleton, we're just using a hardcoded value
    state = state.copyWith(
      products: [], // This would be the actual products
      subtotal: 18.20,
      shippingCost: 2.50,
    );
  }

  // Proceed to payment (next step in the checkout process)
  void proceedToPayment() {
    if (state.pickupDate == null) {
      state = state.copyWith(
        hasError: true,
        errorMessage: 'Por favor, seleccione una fecha de recogida.',
      );
      return;
    }

    // Set submitting state
    state = state.copyWith(
      isSubmitting: true,
      hasError: false,
      errorMessage: null,
    );

    // Here would be the logic to save the order or proceed to the next step
    // For the skeleton, we just simulate a delay
    Future.delayed(const Duration(seconds: 1), () {
      // If successful, would navigate to the next screen
      // For now, just reset the submitting state
      state = state.copyWith(isSubmitting: false);
    });
  }
}
