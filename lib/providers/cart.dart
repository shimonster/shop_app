import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double pricePerItem;

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.pricePerItem,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _cartItems = {};

  Map<String, CartItem> get cartItems {
    return {..._cartItems};
  }

  int get itemCount {
    var count = 0;
    _cartItems.values.forEach((value) => count += value.quantity);
    return count;
  }

  double get totalPrice {
    var total = 0.0;
    _cartItems
        .forEach((key, value) => total += value.quantity * value.pricePerItem);
    return total;
  }

  void addItemToCart(String id, double price, String title) {
    if (_cartItems.containsKey(id)) {
      _cartItems.update(
        id,
        (existingItem) => CartItem(
          id: existingItem.id,
          title: existingItem.title,
          pricePerItem: existingItem.pricePerItem,
          quantity: existingItem.quantity + 1,
        ),
      );
      notifyListeners();
    } else {
      _cartItems.putIfAbsent(
        id,
        () => CartItem(
            id: DateTime.now().toString(),
            title: title,
            quantity: 1,
            pricePerItem: price),
      );
      notifyListeners();
    }
  }

  void removeSingleItem(String productId) {
    if (!_cartItems.containsKey(productId)) {
      return;
    }
    if (_cartItems[productId].quantity > 1) {
      _cartItems.update(
        productId,
        (existing) => CartItem(
          title: existing.title,
          pricePerItem: existing.pricePerItem,
          id: existing.id,
          quantity: existing.quantity - 1,
        ),
      );
    } else {
      _cartItems.remove(productId);
    }
    notifyListeners();
  }

  void removeItemFromCart(String id) {
    _cartItems.remove(id);
    notifyListeners();
  }

  void clearCart() {
    _cartItems = {};
    notifyListeners();
  }
}
