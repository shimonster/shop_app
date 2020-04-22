import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'product.dart';

class Products with ChangeNotifier {
  List<Product> _itmes = [
    Product(
      id: 'p1',
      title: 'Shoes',
      description: 'They are shoes that go on your feet',
      price: 56.99,
      imageURL:
          'https://scene7.zumiez.com/is/image/zumiez/pdp_hero/Champion-Men-s-Rally-Pro-Black-%26-White-Shoes-_298256.jpg',
    ),
    Product(
      id: 'p2',
      title: 'A Pan',
      description: 'This helps you cook on a stove',
      price: 10,
      imageURL:
          'https://ksr-ugc.imgix.net/assets/027/968/475/e0536b6d14c606e1dc5078eba52b41fd_original.jpg?ixlib=rb-2.1.0&crop=faces&w=1024&h=576&fit=crop&v=1580824336&auto=format&frame=1&q=92&s=9b47c49bb6eee6841a347f9fac83dd80',
    ),
    Product(
      id: 'p3',
      title: 'A Mouse',
      description: 'This top of the line mouse is very smooth',
      price: 70.89,
      imageURL:
          'https://ae01.alicdn.com/kf/HTB1WOYJMOLaK1RjSZFxq6ymPFXam/2-4G-Wireless-Vertical-Mouse-EasySMX-G814-Computer-Mouse-4-DPI-Settings-6-Buttons-Optical-Ergonomic.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Papaya',
      description: 'This very good food is awsome',
      price: 70.89,
      imageURL: 'https://draxe.com/wp-content/uploads/2017/06/PapayaHeader.jpg',
    ),
  ];

  List<Product> get items {
    return [..._itmes];
  }

  List<Product> get favoriteItems {
    return items.where((product) => product.isFavorite).toList();
  }

  Product filterForId(String id) {
    return items.firstWhere((item) => item.id == id);
  }

  Future<void> addProduct(Product product) {
    const url = 'https://shop-app-484cd.firebaseio.com/products.json';
    http
        .post(url,
            body: json.encode({
              'title': product.description,
              'descrition': product.description,
              'imageURL': product.imageURL,
              'price': product.price,
              'isFavorite': product.isFavorite,
            }))
        .then((response) {
      final newProduct = Product(
        title: product.title,
        price: product.price,
        description: product.description,
        imageURL: product.imageURL,
        id: json.decode(response.body)['name'],
      );
      _itmes.insert(0, newProduct);
      notifyListeners();
    });
  }

  void editProduct(String id, Product newProduct) {
    final editIndex = _itmes.indexWhere((item) => item.id == id);
    if (editIndex >= 0) {
      _itmes[editIndex] = newProduct;
      notifyListeners();
    }
  }

  void deleteProduct(String id) {
    final deleteIndex = _itmes.indexWhere((item) => item.id == id);
    _itmes.removeAt(deleteIndex);
    notifyListeners();
  }
}
