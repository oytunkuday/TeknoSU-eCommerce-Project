// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teknosu_mobile/providers/providers.dart';

import '../widgets/_widgets.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = '/';
  const HomeScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName), builder: (_) => HomeScreen());
  }

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      final userData = Provider.of<Auth>(context, listen: false);
      final user = userData.user;
      if (user.id != "") {
        Provider.of<Orders>(context, listen: false)
            .getOrdersByUserId(context, user.id);
        Provider.of<CartProducts>(context, listen: false)
            .getCartProductsWithToken(userData.token);
        Provider.of<WishlistProducts>(context, listen: false)
            .getWishlistProductsWithToken(userData.token);
      }
      Provider.of<Products>(context).fetchAndSetProducts();
      Provider.of<Products>(context).fetchAndSetMostPopularProducts();
      Provider.of<Products>(context).fetchAndSetRunningOutProducts();
      Provider.of<Categories>(context).fetchAndSetCategories().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    final products = productsData.items.toList();
    final mostPopularProducts = productsData.mostPopularProducts;
    final activeMostPopularProducts = mostPopularProducts
        .where((product) => product.status == "active")
        .toList();
    final runningOutProducts = productsData.runningOutProducts;
    final activeRunningOutProducts = runningOutProducts
        .where((product) => product.status == "active")
        .toList();
    final activeProducts =
        products.where((product) => product.status == "active").toList();
    final categoryData = Provider.of<Categories>(context);
    final categories = categoryData.categories;
    final userData = Provider.of<Auth>(context);
    final activeCategories =
        categories.where((category) => category.status == "active").toList();
    return Scaffold(
      appBar: CustomAppBar(title: 'TeknoSU'),
      bottomNavigationBar: CustomNavBar(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  SectionTitle(title: 'CATEGORIES'),
                  Container(
                    child: CarouselSlider(
                      options: CarouselOptions(
                        aspectRatio: 1.5,
                        viewportFraction: 0.9,
                        enlargeCenterPage: true,
                        enlargeStrategy: CenterPageEnlargeStrategy.height,
                        initialPage: 0,
                        autoPlay: false,
                      ),
                      items: userData.user.role == "productManager"
                          ? categories
                              .map((category) =>
                                  HeroCarouselCard(category: category))
                              .toList()
                          : activeCategories
                              .map((category) =>
                                  HeroCarouselCard(category: category))
                              .toList(),
                    ),
                  ),
                  SectionTitle(title: 'RUNNING OUT'),
                  // THEY MAY BE LARGER
                  ProductCarousel(
                      products: userData.user.role == "productManager"
                          ? runningOutProducts
                          : activeRunningOutProducts),
                  SectionTitle(title: 'MOST POPULAR'),
                  ProductCarousel(
                      products: userData.user.role == "productManager"
                          ? mostPopularProducts
                          : activeMostPopularProducts)
                ],
              ),
            ),
    );
  }
}
