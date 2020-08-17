import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    @required this.isFavorite = false
  });

  Future<void> toggleFavoritesProduct(String authToken,String userId) async {
    final url = 'https://shopapp-10706.firebaseio.com/userFavorite/$userId/$id.json?auth=$authToken';

    var prevousFav=isFavorite;

      isFavorite = !isFavorite;
    notifyListeners();

    try {
        final response = await http.put(url, body: json.encode(

          isFavorite
        ));
        if(response.statusCode>=400){
          isFavorite=prevousFav;
          notifyListeners();
        }
      }
      catch(error){
    isFavorite=prevousFav;
    notifyListeners();

    throw error;
      }
  }
}
