import 'package:flutter/foundation.dart';
import 'package:teknosu_mobile/providers/providers.dart';

import '../providers.dart';

class ProductReview with ChangeNotifier {
  final Review review;
  final Product product;

  ProductReview({
    required this.review,
    required this.product,
  });
}
