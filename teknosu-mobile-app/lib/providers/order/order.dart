import 'package:flutter/foundation.dart';
import 'package:teknosu_mobile/providers/providers.dart';

class Order with ChangeNotifier {
  final String id;
  final String status;
  final String userId;
  final List<OrderProduct> products; //dynamic can be product, integer
  final String address;
  final int zipCode;
  final String city;
  final String country;
  final String paymentId;
  final String deliveryId;
  final double orderTotal;
  final DateTime createdAt;

  Order({
    required this.id,
    required this.status,
    required this.userId,
    required this.products,
    required this.address,
    required this.zipCode,
    required this.city,
    required this.country,
    required this.paymentId,
    required this.deliveryId,
    required this.orderTotal,
    required this.createdAt,
  });
}

class OrderProduct with ChangeNotifier {
  final Product product;
  final int quantity;
  final double price;
  final String refunded;

  OrderProduct(
      {required this.product,
      required this.quantity,
      required this.price,
      required this.refunded});
}
