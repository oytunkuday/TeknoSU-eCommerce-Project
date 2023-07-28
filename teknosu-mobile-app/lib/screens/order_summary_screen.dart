// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teknosu_mobile/providers/providers.dart';
import 'package:teknosu_mobile/widgets/_widgets.dart';

class OrderSummaryScreen extends StatefulWidget {
  const OrderSummaryScreen({Key? key}) : super(key: key);

  static const String routeName = '/orderSummary';

  static Route route() {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => OrderSummaryScreen());
  }

  @override
  State<OrderSummaryScreen> createState() => _OrderSummaryScreenState();
}

class _OrderSummaryScreenState extends State<OrderSummaryScreen> {
  List<Product> userCartProducts = [];
  var _isInit = true;
  var _isLoading = false;

  @override
  void didChangeDependencies() async {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      await Future.delayed(const Duration(milliseconds: 100), () {});
      final cartProductsData =
          Provider.of<CartProducts>(context, listen: false);
      final cartProducts = cartProductsData.cartProducts;
      var list = await Future.wait(cartProducts.map((cartElement) async =>
          await Provider.of<Products>(context, listen: false)
              .getProductById(cartElement.productId)));
      _isLoading = false;
      setState(() {
        userCartProducts = list;
        _isLoading = false;
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final creditCardData = Provider.of<CreditCardInstance>(context);
    final cartProductsData = Provider.of<CartProducts>(context);
    final cartProducts = cartProductsData.cartProducts;
    var totalPrice = cartProductsData.totalPrice;
    final orderInfoData = Provider.of<OrderInfoInstance>(context);
    return Scaffold(
      appBar: CustomAppBar(title: 'Summary'),
      bottomNavigationBar: CustomNavBar(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  CartList(
                    userCartProducts: userCartProducts,
                    cartProducts: cartProducts,
                    isSummary: true,
                  ),
                  PreOrderInfoCard(
                    orderInfo: orderInfoData.orderInfo,
                    creditCard: creditCardData.creditCard,
                  ),
                  OrderSummary(totalPrice: totalPrice, isSummary: true),
                ],
              ),
            ),
    );
  }
}
