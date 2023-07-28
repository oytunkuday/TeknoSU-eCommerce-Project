import 'package:flutter/foundation.dart';

class Category with ChangeNotifier {
  final String id;
  final String name;
  final String imageUrl;
  final String status;

  Category(
      {required this.id,
      required this.name,
      required this.imageUrl,
      this.status = "active"});
}
