import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:teknosu_mobile/providers/providers.dart';

import 'productReview.dart';
import 'review.dart';

class Reviews with ChangeNotifier {
  String baseUrl = 'http://10.0.2.2:3000/api/v1/';
  List<Review> _reviews = [];
  bool _isPatchExist = true;
  void setIsPatchExist(bool status) {
    _isPatchExist = status;
  }

  bool get isPatchExist {
    return _isPatchExist;
  }

  List<Review> get reviews {
    return [..._reviews];
  }

  List<ProductReview> _pendingReviews = [];
  List<ProductReview> get pendingReviews {
    return [..._pendingReviews];
  }

  List<ProductReview> _approvedReviews = [];
  List<ProductReview> get approvedReviews {
    return [..._approvedReviews];
  }

  List<ProductReview> _disapprovedReviews = [];
  List<ProductReview> get disapprovedReviews {
    return [..._disapprovedReviews];
  }

  List<Review> _reviewsById = [];

  List<Review> get reviewsById {
    return [..._reviewsById];
  }

  Future<void> createReviewByProductId(
      String id, double rating, String review, String token) async {
    final url = Uri.parse("${baseUrl}reviews");
    try {
      final response = await http.post(url,
          body: json.encode(
            {
              'review': review,
              'rating': rating,
              'product': id,
              'user': 'Atakan'
            },
          ),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token'
          });
      final responseData = json.decode(response.body);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> patchReview(
      {required String token,
      required String reviewId,
      required String status}) async {
    final url = Uri.parse('${baseUrl}reviews/$reviewId');
    try {
      final response = await http.patch(url,
          body: json.encode(
            {'approved': status},
          ),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': 'Bearer $token'
          });
      final responseData = json.decode(response.body);
      setIsPatchExist(true);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> fetchAndSetReviews() async {
    final url = Uri.parse('${baseUrl}reviews');
    final response = await http.get(url);

    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    final List<Review> loadedReviews = [];
    extractedData['data']['reviews'].forEach((reviewData) {
      loadedReviews.add(Review(
          id: reviewData['_id'],
          review: reviewData['review'] ?? '',
          rating: reviewData['rating'],
          productId: reviewData['product'],
          userName: reviewData['user'],
          approved: reviewData['approved']));
    });
    _reviews = loadedReviews;
    notifyListeners();
  }

  Future<void> getReviewsByStatus(
      BuildContext context, String token, String status) async {
    final url = Uri.parse('${baseUrl}reviews?approved=${status}');
    final response =
        await http.get(url, headers: {'Authorization': 'Bearer $token'});
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    final List<ProductReview> loadedReviews = [];
    extractedData['data']['reviews'].forEach((reviewData) async {
      var loadedProduct = await Provider.of<Products>(context, listen: false)
          .getProductById(reviewData['product']);
      var loadedReview = Review(
          id: reviewData['_id'],
          review: reviewData['review'] ?? '',
          rating: double.parse(reviewData['rating'].toString()),
          productId: reviewData['product'],
          userName: reviewData['user'],
          approved: reviewData['approved']);
      loadedReviews
          .add(ProductReview(review: loadedReview, product: loadedProduct));
    });
    if (status == 'not reviewed') {
      _pendingReviews = loadedReviews;
    }
    if (status == 'true') {
      _approvedReviews = loadedReviews;
    }
    if (status == 'false') {
      _disapprovedReviews = loadedReviews;
    }
    notifyListeners();
  }

  Future<void> fetchAndSetReviewsByProductId(String id) async {
    final url = Uri.parse('${baseUrl}reviews?product=$id&approved=true');
    final response = await http.get(url);

    final extractedData = json.decode((response.body)) as Map<String, dynamic>;
    final List<Review> loadedReviews = [];
    extractedData['data']['reviews'].forEach((reviewData) {
      loadedReviews.add(Review(
          id: reviewData['_id'],
          review: reviewData['review'] ?? '',
          rating: double.parse(reviewData['rating'].toStringAsFixed(1)),
          productId: reviewData['product'],
          userName: reviewData['user'],
          approved: reviewData['approved']));
    });
    _reviewsById = loadedReviews;
    notifyListeners();
  }
}
