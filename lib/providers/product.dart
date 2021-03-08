import 'dart:convert';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:e_commerce/models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product(
      {@required this.id,
      @required this.title,
      @required this.description,
      @required this.price,
      @required this.imageUrl,
      this.isFavorite = false});

  Future<void> toggleFavorite(String token, String userId) async {
    var oldval = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final baseUrl =
        'https://flutter-ecommerce-1-2d485-default-rtdb.firebaseio.com/userFavorits/$userId/$id.json?auth=$token';

    final response = await http.put(
      baseUrl,
      body: json.encode(isFavorite),
    );
    if (response.statusCode >= 400) {
      isFavorite = oldval;
      notifyListeners();
      throw HttpException('Network error');
    }
  }
}
