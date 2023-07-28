import 'package:flutter/foundation.dart';

class WishlistProduct with ChangeNotifier {
  final String productId;

  WishlistProduct({
    required this.productId,
  });
}
