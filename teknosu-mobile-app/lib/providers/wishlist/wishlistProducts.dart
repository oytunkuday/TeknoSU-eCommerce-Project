import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:teknosu_mobile/providers/wishlist/wishlistProduct.dart';

class WishlistProducts with ChangeNotifier {
  String baseUrl = 'http://10.0.2.2:3000/api/v1/';
  List<WishlistProduct> _wishlistProducts = [];

  List<WishlistProduct> get wishlistProducts {
    return [..._wishlistProducts];
  }

  Future<void> getWishlistProductsWithToken(String token) async {
    String urlString = '${baseUrl}wishlist/getWishlist';
    final url = Uri.parse(urlString);
    final response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    final List<WishlistProduct> loadedWishlistProducts = [];
    extractedData['products'].forEach((product) {
      loadedWishlistProducts
          .add(WishlistProduct(productId: product['productId']));
    });
    _wishlistProducts = loadedWishlistProducts;
    notifyListeners();
  }

  Future<void> addToWishlist(
      {required String token, required String productId}) async {
    Map<String, String> body = {'productId': productId};
    Map<String, String> headers = {'Authorization': 'Bearer $token'};
    final url = Uri.parse('${baseUrl}wishlist/addToWishlist');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(body));
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final List<WishlistProduct> loadedWishlistProducts = [];
    responseData['products'].forEach((product) {
      loadedWishlistProducts
          .add(WishlistProduct(productId: product['productId']));
    });
    _wishlistProducts = loadedWishlistProducts;
    notifyListeners();
  }

  Future<void> removeFromWishlist(
      {required String token, required String productId}) async {
    Map<String, dynamic> body = {'productId': productId};
    final url = Uri.parse('${baseUrl}wishlist/removeFromWishlist');
    final response = await http.post(url,
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(body));
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    final List<WishlistProduct> loadedWishlistProducts = [];
    responseData['products'].forEach((product) {
      loadedWishlistProducts
          .add(WishlistProduct(productId: product['productId']));
    });
    _wishlistProducts = loadedWishlistProducts;
    notifyListeners();
  }
}
