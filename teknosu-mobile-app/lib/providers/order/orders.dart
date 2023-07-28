import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:teknosu_mobile/providers/cart/cartProduct.dart';
import 'package:teknosu_mobile/providers/providers.dart';

import 'order.dart';

class Orders with ChangeNotifier {
  String baseUrl = 'http://10.0.2.2:3000/api/v1/';
  List<Order> _orders = [];

  List<Order> get orders {
    return [..._orders];
  }

  Future<void> getOrdersByUserId(BuildContext context, String userId) async {
    String urlString = '${baseUrl}orders/getOrderByUser?userid=$userId';
    final url = Uri.parse(urlString);
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    final List<Order> loadedOrders = [];
    extractedData['data']['orders'].forEach((orderData) {
      List<OrderProduct> loadedProducts = [];
      orderData['products'].forEach((prodData) async {
        var loadedProduct = await Provider.of<Products>(context, listen: false)
            .getProductById(prodData['productId']);
        loadedProducts.add(OrderProduct(
            product: loadedProduct,
            quantity: prodData['quantity'],
            price: double.parse(prodData['price'].toString()),
            refunded: prodData['refunded']));
      });
      loadedOrders.add(Order(
          id: orderData['_id'],
          status: orderData['status'],
          userId: orderData['user'],
          products: loadedProducts,
          address: orderData['address'],
          zipCode: orderData['zipCode'],
          city: orderData['city'],
          country: orderData['country'],
          paymentId: orderData['paymentId'],
          deliveryId: orderData['deliveryId'],
          orderTotal:
              double.tryParse(orderData['orderTotal'].toString()) ?? 0.0,
          createdAt: DateTime.parse(orderData['createdAt'])));
    });
    _orders = loadedOrders;
    notifyListeners();
  }

  Future<void> changeOrderStatusById(
      {required String token,
      required String orderId,
      required String newStatus}) async {
    String urlString = '${baseUrl}orders/$orderId';
    final url = Uri.parse(urlString);
    final response = await http.patch(
      url,
      body: json.encode({'status': newStatus}),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    setIsPatchExist(true);
    notifyListeners();
  }

  Future<void> completeOrder(
      BuildContext context,
      String name,
      String address,
      String city,
      String country,
      int zipCode,
      List<CartProduct> products,
      double orderTotal,
      String userId,
      String token) async {
    String urlString = '${baseUrl}orders/complete';
    var productList = await Future.wait(products
        .map((e) async => {
              "productId": e.productId,
              "quantity": int.parse(e.quantity.toString()),
              "description": e.productName,
              "price": double.parse(
                  await Provider.of<Products>(context, listen: false)
                      .getPriceOfProductById(e.productId))
            })
        .toList());
    final url = Uri.parse(urlString);
    final response = await http.post(
      url,
      body: jsonEncode({
        'address': address,
        'city': city,
        'country': country,
        'zipCode': zipCode,
        'paymentId': 'oki',
        'user': userId,
        'name': name,
        'products': productList,
        'orderTotal': orderTotal
      }),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final responseData = json.decode(response.body) as Map<String, dynamic>;
  }

  bool _isPatchExist = true;
  void setIsPatchExist(bool status) {
    _isPatchExist = status;
  }

  bool get isPatchExist {
    return _isPatchExist;
  }

  List<Order> _processingOrders = [];
  List<Order> get processingOrders {
    return [..._processingOrders];
  }

  List<Order> _inTransitOrders = [];
  List<Order> get inTransitOrders {
    return [..._inTransitOrders];
  }

  List<Order> _deliveredOrders = [];
  List<Order> get deliveredOrders {
    return [..._deliveredOrders];
  }

  List<Order> _cancelledOrders = [];
  List<Order> get cancelledOrders {
    return [..._cancelledOrders];
  }

  Future<void> getOrdersByStatus(
      BuildContext context, String token, String status) async {
    final url = Uri.parse('${baseUrl}orders?status=$status');
    final response = await http.get(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    final List<Order> loadedOrders = [];
    extractedData['data']['orders'].forEach((orderData) {
      List<OrderProduct> loadedProducts = [];
      orderData['products'].forEach((prodData) async {
        var loadedProduct = await Provider.of<Products>(context, listen: false)
            .getProductById(prodData['productId']);
        loadedProducts.add(OrderProduct(
            product: loadedProduct,
            quantity: prodData['quantity'],
            price: double.parse(prodData['price'].toString()),
            refunded: prodData['refunded']));
      });
      loadedOrders.add(Order(
          id: orderData['_id'],
          status: orderData['status'],
          userId: orderData['user'],
          products: loadedProducts,
          address: orderData['address'],
          zipCode: orderData['zipCode'],
          city: orderData['city'],
          country: orderData['country'],
          paymentId: orderData['paymentId'],
          deliveryId: orderData['deliveryId'],
          orderTotal: double.tryParse(orderData['orderTotal'].toString()) ?? 0,
          createdAt: DateTime.parse(orderData['createdAt'])));
    });
    if (status == 'Processing') {
      _processingOrders = loadedOrders;
    }
    if (status == 'In-Transit') {
      _inTransitOrders = loadedOrders;
    }
    if (status == 'Delivered') {
      _deliveredOrders = loadedOrders;
    }
    if (status == 'Cancelled') {
      _cancelledOrders = loadedOrders;
    }
    notifyListeners();
  }

  Future<void> requestRefundForProduct(
      {required String productId,
      required String orderId,
      required String token}) async {
    String urlString = '${baseUrl}orders/refund/$orderId';
    final url = Uri.parse(urlString);
    final response = await http.patch(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'productId': productId,
      }),
    );
    setIsPatchExist(true);
  }
}
