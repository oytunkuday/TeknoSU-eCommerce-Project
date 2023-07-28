// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';
import '../widgets/_widgets.dart';

class CartScreen extends StatefulWidget {
  static const String routeName = '/cart';
  const CartScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName), builder: (_) => CartScreen());
  }

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Product> userCartProducts = [];
  var _isInit = true;
  var _isLoading = false;
  double cartTotal = 0;

  @override
  void didChangeDependencies() async {
    setState(() {
      _isLoading = true;
    });
    await Future.delayed(const Duration(milliseconds: 100), () {});
    final cartProductsData = Provider.of<CartProducts>(context, listen: false);
    final cartProducts = cartProductsData.cartProducts;
    var list = await Future.wait(cartProducts.map((cartElement) async =>
        await Provider.of<Products>(context, listen: false)
            .getProductById(cartElement.productId)));
    setState(() {
      userCartProducts = list;
      _isLoading = false;
    });

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final cartProductsData = Provider.of<CartProducts>(context);
    final cartProducts = cartProductsData.cartProducts;
    var totalPrice = cartProductsData.totalPrice;
    return Scaffold(
      appBar: CustomAppBar(title: 'Cart'),
      bottomNavigationBar: CustomNavBar(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CartList(
                    userCartProducts: userCartProducts,
                    cartProducts: cartProducts),
                OrderSummary(totalPrice: totalPrice)
              ],
            ),
    );
  }
}
