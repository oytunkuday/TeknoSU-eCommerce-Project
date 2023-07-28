import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'cartProduct.dart';

class CartProducts with ChangeNotifier {
  String baseUrl = 'http://10.0.2.2:3000/api/v1/';
  List<CartProduct> _cartProducts = [];

  List<CartProduct> get cartProducts {
    return [..._cartProducts];
  }

  double _totalPrice = 0;

  double get totalPrice {
    return _totalPrice;
  }

  void setTotalPrice(double totalPrice) {
    _totalPrice = totalPrice;
  }

  Future<void> getCartProductsWithToken(String token) async {
    String urlString = '${baseUrl}cart/getCart';
    final url = Uri.parse(urlString);
    final response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    final List<CartProduct> loadedCartProducts = [];
    extractedData['cart']['products'].forEach((product) {
      loadedCartProducts.add(CartProduct(
          productId: product['productId'],
          quantity: product['quantity'],
          productName: product['name'] ?? ""));
    });
    _cartProducts = loadedCartProducts;
    _totalPrice = double.parse(extractedData['totalprice'].toString());
    notifyListeners();
  }

  Future<void> addToCart(
      String prodId, String token, int quantity, String productName) async {
    Map<String, dynamic> body = {
      'productId': prodId,
      'quantity': quantity,
      'name': productName
    };
    String urlString = '${baseUrl}cart/addToCart';
    final url = Uri.parse(urlString);
    final response = await http.post(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode(body),
    );
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    notifyListeners();
  }
}
