import 'package:flutter/foundation.dart';

class CartProduct with ChangeNotifier {
  final String productId;
  final int quantity;
  final String productName;

  CartProduct({
    required this.productId,
    required this.quantity,
    required this.productName,
  });
}
