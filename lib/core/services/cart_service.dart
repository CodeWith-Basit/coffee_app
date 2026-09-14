import 'package:coffee_appv2/models/cart_item.dart';
import 'package:flutter/foundation.dart';

class CartService {
  CartService._();
  static final CartService instance = CartService._();

  /// ValueNotifier holding the current cart items so UI widgets can reactively rebuild
  final ValueNotifier<List<CartItem>> cartNotifier =
      ValueNotifier<List<CartItem>>([]);

  List<CartItem> get items => cartNotifier.value;

  /// Check if item is already in cart
  bool isInCart(String title) {
    return cartNotifier.value.any((element) => element.title == title);
  }

  /// Add item to cart. Returns true if newly added, false if already in cart.
  bool addToCart({
    required String title,
    required String imgurl,
    required double price,
    String? subtitle,
  }) {
    final currentList = List<CartItem>.from(cartNotifier.value);
    final index = currentList.indexWhere((element) => element.title == title);

    if (index != -1) {
      return false; // Already in cart
    } else {
      currentList.add(
        CartItem(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          title: title,
          imgurl: imgurl,
          price: price,
          subtitle: subtitle,
          quantity: 1,
        ),
      );
      cartNotifier.value = currentList;
      return true; // Newly added
    }
  }

  /// Increment quantity of existing item
  void incrementQuantity(int index) {
    if (index < 0 || index >= cartNotifier.value.length) return;
    final currentList = List<CartItem>.from(cartNotifier.value);
    currentList[index].quantity++;
    cartNotifier.value = currentList;
  }

  /// Decrement quantity or remove if reaching 0
  void decrementQuantity(int index) {
    if (index < 0 || index >= cartNotifier.value.length) return;
    final currentList = List<CartItem>.from(cartNotifier.value);
    if (currentList[index].quantity > 1) {
      currentList[index].quantity--;
    } else {
      currentList.removeAt(index);
    }
    cartNotifier.value = currentList;
  }

  /// Remove item completely from cart
  void removeItem(int index) {
    if (index < 0 || index >= cartNotifier.value.length) return;
    final currentList = List<CartItem>.from(cartNotifier.value);
    currentList.removeAt(index);
    cartNotifier.value = currentList;
  }

  /// Clear the entire cart
  void clearCart() {
    cartNotifier.value = [];
  }

  /// Total price of all items in cart
  double get subtotal =>
      cartNotifier.value.fold(0.0, (sum, item) => sum + item.totalPrice);
}
