import 'package:flutter/foundation.dart';

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

  void addOrder(List<CartItem> cartProducts, double total) {
    _orders.insert(
      0,
      Order(DateTime.now().toString(), total, cartProducts, DateTime.now()),
    );
    notifyListeners();
  }
}
