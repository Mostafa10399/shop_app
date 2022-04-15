import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;

  bool isFavorite;
  Product(
      {@required this.id,
      @required this.description,
      @required this.imageUrl,
      this.isFavorite = false,
      @required this.price,
      @required this.title});
  void _setValue(bool newVal) {
    isFavorite = newVal;
    notifyListeners();
  }

  Future<void> toggleFavoriteStates(String token, String userID) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url = Uri.parse(
        'https://shop-app-ae497-default-rtdb.firebaseio.com/userFavorite/$userID/$id.json?auth=$token');

    try {
      final response = await http.put(url, body: json.encode(isFavorite));
      if (response.statusCode >= 400) {
        _setValue(oldStatus);
      }
    } catch (error) {
      _setValue(oldStatus);
      throw error;
    }
  }
}
