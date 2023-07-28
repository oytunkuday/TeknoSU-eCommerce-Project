import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'category.dart';

class Categories with ChangeNotifier {
  String baseUrl = 'http://10.0.2.2:3000/api/v1/';
  List<Category> _categories = [];

  List<Category> get categories {
    return [..._categories];
  }

  bool _isPatchExist = true;
  void setIsPatchExist(bool status) {
    _isPatchExist = status;
  }

  bool get isPatchExist {
    return _isPatchExist;
  }

  Future<void> fetchAndSetCategories() async {
    final url = Uri.parse('${baseUrl}categories');
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    final List<Category> loadedCategories = [];
    extractedData['data']['categories'].forEach((categoryData) {
      loadedCategories.add(Category(
          id: categoryData['_id'],
          name: categoryData['name'],
          imageUrl: categoryData['photo'],
          status: categoryData['status']));
    });
    _categories = loadedCategories;
    notifyListeners();
  }

  Future<void> addNewCategory(
      {required String token,
      required String name,
      required String photo}) async {
    final url = Uri.parse('${baseUrl}categories/addCategory');
    final response = await http.post(url,
        body: json.encode(
          {
            'photo': photo,
            'name': name,
          },
        ),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        });
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    notifyListeners();
  }

  Future<void> deleteCategory(
      {required String token, required String id}) async {
    final url = Uri.parse("${baseUrl}categories/$id");
    await http.delete(
      url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        'Authorization': 'Bearer $token'
      },
    );
    setIsPatchExist(true);
    notifyListeners();
  }

  Future<void> activateCategory(
      {required String token, required String id}) async {
    final url = Uri.parse("${baseUrl}categories/activate/$id");
    final response = await http.patch(url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
        body: json.encode({'status': 'active'}));
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    setIsPatchExist(true);
    notifyListeners();
  }
}
