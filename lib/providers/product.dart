import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageURL;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageURL,
    this.isFavorite = false,
  });

//  void changeFavoriteStatus () {
//    isFavorite = !isFavorite;
//    notifyListeners();
//  }

  Future<void> changeFavoriteStatus() async {
    final url = 'https://shop-app-484cd.firebaseio.com/products/$id.json';
    var prevFavoriteStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final response =
        await http.patch(url, body: json.encode({'isFavorite': !isFavorite}));
    notifyListeners();
    if (response.statusCode >= 400) {
      isFavorite = prevFavoriteStatus;
      notifyListeners();
      prevFavoriteStatus = null;
      throw HttpException('could not favorite product');
    }
  }
}
