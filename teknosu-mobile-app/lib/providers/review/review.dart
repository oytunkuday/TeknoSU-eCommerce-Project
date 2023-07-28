import 'package:flutter/foundation.dart';

class Review with ChangeNotifier {
  final String id;
  final String review;
  final double rating;
  final String productId;
  final String userName;
  final String approved;

  Review(
      {required this.id,
      this.review = '',
      required this.rating,
      required this.productId,
      required this.userName,
      required this.approved});
}
