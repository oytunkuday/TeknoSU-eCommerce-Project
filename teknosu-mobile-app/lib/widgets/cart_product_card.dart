// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teknosu_mobile/providers/providers.dart';

class CartProductCard extends StatefulWidget {
  const CartProductCard({
    Key? key,
    required this.product,
    required this.quantity,
    this.isSummary = false,
  }) : super(key: key);

  final Product product;
  final int quantity;
  final bool isSummary;
  @override
  State<CartProductCard> createState() => _CartProductCardState();
}

class _CartProductCardState extends State<CartProductCard> {
  Future<void> _addToCart(String prodId, String token, String name) async {
    try {
      await Provider.of<CartProducts>(context, listen: false)
          .addToCart(prodId, token, 1, name);
      await Provider.of<CartProducts>(context, listen: false)
          .getCartProductsWithToken(token);
    } catch (error) {
      throw error;
    }
  }

  Future<void> _removeFromCart(
      String prodId, String token, double price, String name) async {
    try {
      await Provider.of<CartProducts>(context, listen: false)
          .addToCart(prodId, token, -1, name);
      await Provider.of<CartProducts>(context, listen: false)
          .getCartProductsWithToken(token);
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context);
    final token = authData.token;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Image.network(widget.product.imgs,
              width: 100, height: 80, fit: BoxFit.contain),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.product.name,
                    style: Theme.of(context).textTheme.headline5),
                Row(
                  children: [
                    Text(
                      '\$${widget.product.price}',
                      style: widget.product.discount != 0
                          ? Theme.of(context)
                              .textTheme
                              .bodyText1!
                              .copyWith(decoration: TextDecoration.lineThrough)
                          : Theme.of(context).textTheme.headline6,
                    ),
                    SizedBox(
                      width: 7,
                    ),
                    if (widget.product.discount != 0)
                      Text('\$${(widget.product.newPrice).toStringAsFixed(1)}',
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(color: Colors.red.shade500))
                  ],
                ),
              ],
            ),
          ),
          SizedBox(width: 10),
          Row(
            children: [
              !widget.isSummary
                  ? IconButton(
                      onPressed: () {
                        _removeFromCart(widget.product.id, token,
                            widget.product.price, widget.product.name);
                      },
                      icon: Icon(Icons.remove_circle))
                  : SizedBox(
                      width: 8,
                    ),
              Text(
                '${widget.quantity}',
                style: Theme.of(context).textTheme.headline4,
              ),
              !widget.isSummary
                  ? IconButton(
                      onPressed: () {
                        _addToCart(
                            widget.product.id, token, widget.product.name);
                      },
                      icon: Icon(Icons.add_circle))
                  : SizedBox(
                      width: 8,
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
