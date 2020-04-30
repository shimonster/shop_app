import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import './cart.dart';

class Order {
  final String id;
  final double price;
  final List<CartItem> products;
  final DateTime dateTime;

  Order(this.id, this.price, this.products, this.dateTime);
}

class Orders with ChangeNotifier {
  List<Order> _orders = [];

  List<Order> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    const url = 'https://shop-app-484cd.firebaseio.com/orders.json';
    final List<Map<String, dynamic>> products = cartProducts.map((value) {
      return value.mapVersion;
    }).toList();
    await http.post(
      url,
      body: json.encode({
        'price': total,
        'products': products,
        'date': DateTime.now().toString(),
      }),
    );
  }

  Future<void> getOrders() async {
    const url = 'https://shop-app-484cd.firebaseio.com/orders.json';
    final List<Order> loadedOrders = [];
    final response = await http.get(url);
    final rawLoadedOrders = json.decode(response.body) as Map<String, dynamic>;
    rawLoadedOrders.forEach((newId, ordValues) {
      final List/*<Map<String, dynamic>>*/ cartItemMaps = ordValues['products'];
      List<CartItem> cartItems = [];
      cartItemMaps.forEach((value) {
        cartItems.add(
          CartItem(
            id: value['id'],
            title: value['title'],
            pricePerItem: value['pricePerItem'],
            quantity: value['quantity'],
          ),
        );
      });
      loadedOrders.add(
        Order(
          newId,
          ordValues['price'],
          cartItems,
          DateTime.parse(ordValues['date']),
        ),
      );
    });
    _orders = loadedOrders;
    print(['provider',_orders]);
    notifyListeners();
  }
}
