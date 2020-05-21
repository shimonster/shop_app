import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import './product.dart';
import '../models/http_exception.dart';

class Products with ChangeNotifier {
  final String token;
  List<Product> _items;
  final String userId;

  Products(this.token, this._items, this.userId);

  List<Product> get items {
    return [..._items];
  }

  List<Product> get favoriteItems {
    return items.where((product) => product.isFavorite).toList();
  }

  Product filterForId(String id) {
    return items.firstWhere((item) => item.id == id);
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://shop-app-484cd.firebaseio.com/products.json?auth=$token';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.description,
            'descrition': product.description,
            'imageURL': product.imageURL,
            'price': product.price,
            'creatorId': userId,
          },
        ),
      );
      final newProduct = Product(
        title: product.title,
        price: product.price,
        description: product.description,
        imageURL: product.imageURL,
        id: json.decode(response.body)['name'],
      );
      _items.insert(0, newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> getProducts(bool filterByUser) async {
    final filterString =
        filterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : '';
    final url =
        'https://shop-app-484cd.firebaseio.com/products.json?auth=$token$filterString';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      final List<Product> loadedProducts = [];
      if (extractedData == null) {
        return;
      }
      final favsUrl =
          'https://shop-app-484cd.firebaseio.com/userFavorites/$userId.json?auth=$token';
      final faves = await http.get(favsUrl);
      print('faves');
      print(json.decode(faves.body));
      extractedData.forEach((id, info) {
        final favesInfo =
            faves == null ? false : json.decode(faves.body)[id] ?? false;
        print(favesInfo);
        loadedProducts.add(
          Product(
            id: id,
            title: info['title'],
            description: info['description'],
            price: info['price'],
            imageURL: info['imageURL'],
            isFavorite: favesInfo,
          ),
        );
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  Future<void> editProduct(String id, Product newProduct) async {
    final editIndex = _items.indexWhere((item) => item.id == id);
    if (editIndex >= 0) {
      try {
        final url =
            'https://shop-app-484cd.firebaseio.com/products/$id.json?auth=$token';
        await http.patch(
          url,
          body: json.encode({
            'title': newProduct.title,
            'price': newProduct.price,
            'description': newProduct.description,
            'imageURL': newProduct.imageURL,
          }),
        );
        _items[editIndex] = newProduct;
        notifyListeners();
      } catch (error) {
        throw error;
      }
    }
  }

  void deleteProduct(String id) async {
    final url =
        'https://shop-app-484cd.firebaseio.com/products/$id.json?auth=$token';
    final deleteIndex = _items.indexWhere((item) => item.id == id);
    var deleteProduct = _items[deleteIndex];
    _items.removeAt(deleteIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(deleteIndex, deleteProduct);
      deleteProduct = null;
      notifyListeners();
      throw HttpException('Could not delete product.');
    }
    deleteProduct = null;
  }
}
