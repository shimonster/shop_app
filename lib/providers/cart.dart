import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class CartItem {
  final String id;
  final String title;
  final int quantity;
  final double pricePerItem;

  Map<String, dynamic> get mapVersion => {
        'title': title,
        'quantity': quantity,
        'pricePerItem': pricePerItem,
        'id': id,
      };

  CartItem({
    @required this.id,
    @required this.title,
    @required this.quantity,
    @required this.pricePerItem,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _cartItems = {};
  final String userId;
  final String token;

  Cart(this.token, this.userId, this._cartItems) {
    print(cartItems);
  }

  Map<String, CartItem> get cartItems {
    if (_cartItems == null) {
      return {};
    }
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

  Future<void> addItemToCart(String prodId, double price, String title) async {
    try {
      var urlEnd = '';
      final url =
          'https://shop-app-484cd.firebaseio.com/userCartItems/$userId/$urlEnd.json?auth=$token';
      if (_cartItems.containsKey(prodId)) {
        urlEnd = prodId;
        final response = await http.patch(
          url,
          body: json.encode({
            'quantity': _cartItems[prodId].quantity + 1,
          }),
        );
        if (response.statusCode >= 400) {
          throw HttpException('could add item to cart');
        }
        _cartItems.update(
          prodId,
          (existingItem) => CartItem(
            id: existingItem.id,
            title: existingItem.title,
            pricePerItem: existingItem.pricePerItem,
            quantity: existingItem.quantity + 1,
          ),
        );
        notifyListeners();
      } else {
        final rawResponse = await http.post(
          url,
          body: json.encode({
            'prodId': prodId,
            'title': title,
            'quantity': 1,
            'pricePerItem': price,
          }),
        );
        final response = json.decode(rawResponse.body) as Map<String, dynamic>;
        _cartItems.putIfAbsent(
          prodId,
          () => CartItem(
              id: response['name'],
              title: title,
              quantity: 1,
              pricePerItem: price),
        );
        notifyListeners();
      }
    } catch (error) {
      throw error;
    }
  }

  void removeSingleItem(String productId) async {
    if (!_cartItems.containsKey(productId)) {
      return;
    }
    try {
      final url =
          'https://shop-app-484cd.firebaseio.com/userCartItems/$userId/$productId.json?auth=$token';
      if (_cartItems[productId].quantity > 1) {
        final response = await http.patch(
          url,
          body: json.encode({
            'quantity': _cartItems[productId].quantity - 1,
          }),
        );
        if (response.statusCode >= 400) {
          throw HttpException('couldn\'t delete cart item');
        }
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
        final response = await http.delete(url);
        if (response.statusCode >= 400) {
          throw HttpException('couldn\'t delete cart item');
        }
        _cartItems.remove(productId);
      }
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }

  void removeItemFromCart(String prodId) async {
    final url =
        'https://shop-app-484cd.firebaseio.com/userCartItems/$userId/$prodId.json?auth=$token';
    try {
      final response = await http.delete(url);
      if (response.statusCode >= 400) {
        throw HttpException('couldn\'t delete cart item');
      }
      _cartItems.remove(prodId);
    } catch (error) {
      throw error;
    }
    notifyListeners();
  }

  void clearCart() async {
    final url =
        'https://shop-app-484cd.firebaseio.com/userCartItems/$userId.json?auth=$token';
//    try {
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      throw HttpException('couldn\'t clear cart');
    }
    _cartItems = {};
//    } catch (error) {
//      throw error;
//    }
    notifyListeners();
  }
}
