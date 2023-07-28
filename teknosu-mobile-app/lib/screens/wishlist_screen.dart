// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teknosu_mobile/providers/providers.dart';
import 'package:teknosu_mobile/widgets/_widgets.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({Key? key}) : super(key: key);
  static const String routeName = '/wishlist';

  static Route route() {
    return MaterialPageRoute(
      settings: RouteSettings(name: routeName),
      builder: (_) => WishlistScreen(),
    );
  }

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<Product> userWishlist = [];
  var _isLoading = false;

  @override
  void didChangeDependencies() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 100), () {});
    final wishlistData = Provider.of<WishlistProducts>(context, listen: false);
    final wishlistProducts = wishlistData.wishlistProducts;
    var list = await Future.wait(wishlistProducts.map((wishlistElement) async =>
        await Provider.of<Products>(context, listen: false)
            .getProductById(wishlistElement.productId)));
    _isLoading = false;
    setState(() {
      userWishlist = list;
      _isLoading = false;
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final wishlistData = Provider.of<WishlistProducts>(context);
    final authData = Provider.of<Auth>(context);
    return Scaffold(
        appBar: CustomAppBar(title: 'Wishlist'),
        bottomNavigationBar: CustomNavBar(),
        body: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : (authData.isAuth
                ? GridView.builder(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 1, childAspectRatio: 2.4),
                    itemCount: userWishlist.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Center(
                        child: ProductCard(
                          product: userWishlist[index],
                          widthFactor: 1.1,
                          leftPosition: 5,
                          isWishlist: true,
                        ),
                      );
                    },
                  )
                : NotLoggedInButton()));
  }
}
