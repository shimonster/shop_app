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
  final String token;
  List<Order> _orders;

  Orders(this.token, this._orders);

  List<Order> get orders {
    return [..._orders];
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final url = 'https://shop-app-484cd.firebaseio.com/orders.json?auth=$token';
    final timeStamp = DateTime.now();
    final List<Map<String, dynamic>> products = cartProducts.map((value) {
      return value.mapVersion;
    }).toList();
    await http.post(
      url,
      body: json.encode({
        'price': total,
        'products': products,
        'date': timeStamp.toIso8601String(),
      }),
    );
  }

  Future<void> getOrders() async {
    final url = 'https://shop-app-484cd.firebaseio.com/orders.json?auth=$token';
    final List<Order> loadedOrders = [];
    final response = await http.get(url);
    final rawLoadedOrders = json.decode(response.body) as Map<String, dynamic>;
    if (rawLoadedOrders == null) {
      return;
    }
    rawLoadedOrders.forEach((newId, ordValues) {
      loadedOrders.add(
        Order(
          newId,
          ordValues['price'],
          (ordValues['products'] as List<dynamic>)
              .map(
                (value) => CartItem(
                  id: value['id'],
                  title: value['title'],
                  pricePerItem: value['pricePerItem'],
                  quantity: value['quantity'],
                ),
              )
              .toList(),
          DateTime.parse(ordValues['date']),
        ),
      );
    });
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }
}
