import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'product.dart';

class Products with ChangeNotifier {
  String baseUrl = "http://10.0.2.2:3000/api/v1/";
  List<Product> _items = [];
  List<Product> get items {
    return [..._items];
  }

  Product _product = Product(
      id: "",
      name: "",
      brand: "",
      category: "",
      description: "",
      distributor: "",
      price: 0,
      ratingsQuantity: 0,
      ratingsAvg: 0,
      stocks: 0,
      warranty: true,
      recommended: true,
      popular: true,
      imgs: "",
      discount: 0,
      newPrice: 0,
      cost: 0,
      status: 'passive');
  Product get product {
    return _product;
  }

  bool _isPatchExist = true;
  void setIsPatchExist(bool status) {
    _isPatchExist = status;
  }

  bool get isPatchExist {
    return _isPatchExist;
  }

  List<Product> _mostPopularProducts = [];
  List<Product> get mostPopularProducts {
    return _mostPopularProducts
        .where((product) => product.stocks != 0)
        .toList();
  }

  List<Product> _runningOutProducts = [];
  List<Product> get runningOutProducts {
    return _runningOutProducts.where((product) => product.stocks != 0).toList();
  }

  /*List<Product> get favoriteItems {
    return _items.where((prodItem) => prodItem.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }*/

  // void showFavoritesOnly() {
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }

  // void showAll() {
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  Future<void> fetchAndSetProducts(
      {String sort = "Price Ascending",
      String search = "",
      String category = "",
      bool isPopular = false,
      bool isRunningOut = false}) async {
    if (sort == "Price Ascending") {
      sort = "newPrice";
    } else if (sort == "Price Descending") {
      sort = "-newPrice";
    } else if (sort == "Rating Ascending") {
      sort = "ratingsAvg";
    } else if (sort == "Rating Descending") {
      sort = "-ratingsAvg";
    }

    String urlString = '${baseUrl}products?';
    urlString += "sort=" + sort;
    if (search != "") {
      urlString = "${baseUrl}search?name=" + search + "&sort=" + sort;
    }
    if (category != "") {
      urlString += "&category=" + category;
    }
    final url = Uri.parse(urlString);
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    final List<Product> loadedProducts = [];
    extractedData['data']['products'].forEach((prodData) {
      loadedProducts.add(Product(
        id: prodData['_id'],
        name: prodData['name'],
        brand: prodData['brand'],
        category: prodData['category'],
        description: prodData['description'],
        distributor: prodData['distributor'],
        price: double.parse(prodData['price'].toString()),
        ratingsAvg: double.parse(prodData['ratingsAvg'].toStringAsFixed(1)),
        ratingsQuantity: prodData['ratingsQuantity'],
        stocks: prodData['stocks'],
        warranty: prodData['warranty'],
        recommended: prodData['recommended'],
        popular: prodData['popular'],
        imgs: (prodData['imgs'] != null && prodData['imgs'][0] != "")
            ? prodData['imgs'][0]
            : 'https://www.dijitalistmarketing.com/wp-content/themes/consultix/images/no-image-found-360x260.png',
        discount: int.tryParse(prodData['discount'].toString()) ?? 0,
        cost: double.tryParse(prodData['cost'].toString()) ?? 0,
        newPrice: double.tryParse(prodData['newPrice'].toString()) ?? 0,
        status: prodData['status'] ?? "active",
      ));
    });
    if (isPopular) {
      _mostPopularProducts = loadedProducts;
    } else if (isRunningOut) {
      _runningOutProducts = loadedProducts;
    } else {
      _items = loadedProducts;
    }
    notifyListeners();
  }

  Future<void> fetchAndSetMostPopularProducts() async {
    fetchAndSetProducts(sort: "-sold", isPopular: true);
  }

  Future<void> fetchAndSetRunningOutProducts() async {
    fetchAndSetProducts(sort: "stocks", isRunningOut: true);
  }

  Future<Product> getProductById(String id) async {
    String urlString = '${baseUrl}products/$id';
    final url = Uri.parse(urlString);
    final response = await http.get(url);
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    final prodData = extractedData['data']['products'];
    Product product = Product(
      id: prodData['_id'],
      name: prodData['name'],
      brand: prodData['brand'],
      category: prodData['category'],
      description: prodData['description'],
      distributor: prodData['distributor'],
      price: double.parse(prodData['price'].toString()),
      ratingsAvg: double.parse(prodData['ratingsAvg'].toStringAsFixed(1)),
      ratingsQuantity: prodData['ratingsQuantity'],
      stocks: prodData['stocks'],
      warranty: prodData['warranty'],
      recommended: prodData['recommended'],
      popular: prodData['popular'],
      imgs: (prodData['imgs'] != null && prodData['imgs'][0] != "")
          ? prodData['imgs'][0]
          : 'https://www.dijitalistmarketing.com/wp-content/themes/consultix/images/no-image-found-360x260.png',
      discount: int.tryParse(prodData['discount'].toString()) ?? 0,
      cost: double.tryParse(prodData['cost'].toString()) ?? 0,
      newPrice: double.tryParse(prodData['newPrice'].toString()) ?? 0,
      status: prodData['status'] ?? 'active',
    );
    _product = product;
    return product;
  }

  Future<String> getPriceOfProductById(String id) async {
    Product product = await getProductById(id);
    return product.newPrice.toString();
  }

  Future<void> patchProductStock(
      {required String id,
      required String token,
      required int newStock}) async {
    final url = Uri.parse('${baseUrl}products/$id');
    try {
      final response = await http.patch(url,
          body: json.encode(
            {'stocks': newStock},
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

  Future<void> deleteProduct(
      {required String token, required String id}) async {
    final url = Uri.parse("${baseUrl}products/$id");
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

  Future<void> activateProduct(
      {required String token, required String id}) async {
    final url = Uri.parse("${baseUrl}products/$id");
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

  Future<void> addProduct(Product product, String token) async {
    final url = Uri.parse('${baseUrl}products');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'name': product.name,
          'brand': product.brand,
          'category': product.category,
          'description': product.description,
          'distributor': product.distributor,
          'cost': product.cost,
          'price': product.price,
          'stocks': product.stocks,
          'warranty': product.warranty,
          'recommended': true,
          'popular': true,
          'imgs': [product.imgs]
        }),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $token'
        },
      );
      final responseData = json.decode(response.body) as Map<String, dynamic>;
      print(responseData);
      notifyListeners();
    } catch (error) {
      print(error);
      throw error;
    }
  }

  /*
  void updateProduct(String id, Product newProduct) {
    final prodIndex = _items.indexWhere((prod) => prod.id == id);
    if (prodIndex >= 0) {
      _items[prodIndex] = newProduct;
      notifyListeners();
    } else {
      print('...');
    }
  }

  void deleteProduct(String id) {
    _items.removeWhere((prod) => prod.id == id);
    notifyListeners();
  }*/
}
