import 'package:flutter/foundation.dart';

class Product with ChangeNotifier {
  final String id;
  final String name;
  final String brand;
  final String category;
  final String description;
  final String distributor;
  final double price;
  final double ratingsAvg;
  final int ratingsQuantity;
  final int stocks;
  final bool warranty;
  final bool recommended;
  final bool popular;
  final String imgs;
  final int discount;
  final double newPrice;
  final double cost;
  final String status;

  Product({
    required this.id,
    required this.name,
    required this.brand,
    required this.category,
    required this.description,
    required this.distributor,
    required this.price,
    required this.ratingsQuantity,
    required this.ratingsAvg,
    required this.stocks,
    required this.warranty,
    required this.recommended,
    required this.popular,
    required this.imgs,
    required this.discount,
    required this.newPrice,
    required this.cost,
    required this.status,
  });

  /*void _setFavValue(bool newValue) {
    isFavorite = newValue;
    notifyListeners();
  }

  Future<void> toggleFavoriteStatus(String token, String userId) async {
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    notifyListeners();
    final url =
        'https://flutter-update.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );
      if (response.statusCode >= 400) {
        _setFavValue(oldStatus);
      }
    } catch (error) {
      _setFavValue(oldStatus);
    }
  }*/

}
