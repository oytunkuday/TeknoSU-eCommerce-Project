import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class OrderInfo with ChangeNotifier {
  final String name;
  final String address;
  final int zipCode;
  final String city;
  final String country;

  OrderInfo(
      {required this.name,
      required this.address,
      required this.zipCode,
      required this.city,
      required this.country});
}

class OrderInfoInstance with ChangeNotifier {
  OrderInfo _orderInfo =
      OrderInfo(name: '', address: '', zipCode: 0, city: '', country: '');

  OrderInfo get orderInfo {
    return _orderInfo;
  }

  void setOrderInfo(
      {String name = "",
      String address = "",
      int zipCode = 0,
      String city = "",
      String country = ""}) {
    OrderInfo loadedOrderInfo = OrderInfo(
        name: name,
        address: address,
        zipCode: zipCode,
        city: city,
        country: country);
    _orderInfo = loadedOrderInfo;
  }
}
