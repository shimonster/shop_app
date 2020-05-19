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

  Future<void> changeFavoriteStatus(String token, String userId) async {
    final url =
        'https://shop-app-484cd.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    var prevFavoriteStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final response = await http.put(
      url,
      body: json.encode(
        isFavorite,
      ),
    );
    notifyListeners();
    if (response.statusCode >= 400) {
      print('change fav error');
      isFavorite = prevFavoriteStatus;
      notifyListeners();
      prevFavoriteStatus = null;
      throw HttpException('could not favorite product');
    }
  }
}
