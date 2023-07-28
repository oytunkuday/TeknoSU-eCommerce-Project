// ignore_for_file: no_duplicate_case_values, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:teknosu_mobile/providers/providers.dart';

import '../screens/_screens.dart';

class AppRouter {
  static Route onGenerateRoute(RouteSettings settings) {
    print('This is route: ${settings.name}');
    switch (settings.name) {
      case '/':
        return HomeScreen.route();
      case HomeScreen.routeName:
        return HomeScreen.route();
      case ProductScreen.routeName:
        return ProductScreen.route(product: settings.arguments as Product);
      case CartScreen.routeName:
        return CartScreen.route();
      case CatalogScreen.routeName:
        return CatalogScreen.route(category: settings.arguments as Category);
      case LogInScreen.routeName:
        return LogInScreen.route();
      case SignUpScreen.routeName:
        return SignUpScreen.route();
      case ProfileScreen.routeName:
        return ProfileScreen.route();
      case CheckOutScreen.routeName:
        return CheckOutScreen.route();
      case CreditCardScreen.routeName:
        return CreditCardScreen.route();
      case OrderSummaryScreen.routeName:
        return OrderSummaryScreen.route();
      case WishlistScreen.routeName:
        return WishlistScreen.route();
      case ProductManagerScreen.routeName:
        return ProductManagerScreen.route();
      case ManageReviewsScreen.routeName:
        return ManageReviewsScreen.route();
      case ManageOrdersScreen.routeName:
        return ManageOrdersScreen.route();
      case AddCategoryScreen.routeName:
        return AddCategoryScreen.route();
      case AddProductScreen.routeName:
        return AddProductScreen.route();
      case ManageCategoryScreen.routeName:
        return ManageCategoryScreen.route();
      case SaveAddressScreen.routeName:
        return SaveAddressScreen.route();
      default:
        return _errorRoute();
    }
  }

  static Route _errorRoute() {
    return MaterialPageRoute(
      settings: RouteSettings(name: '/error'),
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: Text('Error'),
        ),
      ),
    );
  }
}
