// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teknosu_mobile/providers/providers.dart';

class OrderSummary extends StatefulWidget {
  const OrderSummary({
    Key? key,
    required this.totalPrice,
    this.isSummary = false,
  }) : super(key: key);

  final double totalPrice;
  final bool isSummary;

  @override
  State<OrderSummary> createState() => _OrderSummaryState();
}

class _OrderSummaryState extends State<OrderSummary> {
  var _isLoading = false;

  Future<void> _orderNow(OrderInfo orderInfo, List<CartProduct> cartProducts,
      String token, String userId, double orderTotal) async {
    setState(() {
      _isLoading = true;
    });
    await Provider.of<Orders>(context, listen: false).completeOrder(
        context,
        orderInfo.name,
        orderInfo.address,
        orderInfo.city,
        orderInfo.country,
        orderInfo.zipCode,
        cartProducts,
        orderTotal,
        userId,
        token);
    Navigator.pushNamed(context, '/');
    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderInfo = Provider.of<OrderInfoInstance>(context).orderInfo;
    final creditCardInfo = Provider.of<CreditCardInstance>(context).creditCard;
    final cartProducts = Provider.of<CartProducts>(context).cartProducts;
    final cartTotal = Provider.of<CartProducts>(context).totalPrice;
    final authData = Provider.of<Auth>(context);
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width,
          height: 60,
          decoration: BoxDecoration(
            color: Colors.black.withAlpha(50),
          ),
        ),
        Container(
          margin: EdgeInsets.all(5.0),
          width: MediaQuery.of(context).size.width,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.black,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'TOTAL',
                  style: Theme.of(context)
                      .textTheme
                      .headline5!
                      .copyWith(color: Colors.white),
                ),
                Row(
                  children: [
                    Text(
                      '\$${widget.totalPrice.toStringAsFixed(1)}',
                      style: Theme.of(context)
                          .textTheme
                          .headline5!
                          .copyWith(color: Colors.white),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(primary: Colors.white),
                      onPressed: () {
                        if (widget.isSummary) {
                          _orderNow(orderInfo, cartProducts, authData.token,
                              authData.user.id, cartTotal);
                        } else {
                          Navigator.pushNamed(context, '/checkout');
                        }
                      },
                      child: Text(
                          widget.isSummary ? 'Order Now' : 'Go to Checkout',
                          style: TextStyle(color: Colors.black)),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ],
    );
  }
}
