// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rating_dialog/rating_dialog.dart';
import 'package:teknosu_mobile/providers/providers.dart';

class OrderProductCard extends StatefulWidget {
  const OrderProductCard(
      {Key? key,
      required this.orderProduct,
      required this.status,
      required this.role,
      this.orderId = "",
      required this.orderDate})
      : super(key: key);

  final String orderId;
  final OrderProduct orderProduct;
  final String status;
  final String role;
  final DateTime orderDate;

  @override
  State<OrderProductCard> createState() => _OrderProductCardState();
}

class _OrderProductCardState extends State<OrderProductCard> {
  Future<void> _submit(double rating, String review) async {
    try {
      final userData = Provider.of<Auth>(context, listen: false);
      final token = userData.token;
      await Provider.of<Reviews>(context, listen: false)
          .createReviewByProductId(
              widget.orderProduct.product.id, rating, review, token);
      Navigator.pushNamed(context, "/");
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context);
    DateTime lastRefundDate = widget.orderDate.add(Duration(days: 30));
    bool isRefundPossible = lastRefundDate.isAfter(DateTime.now());
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          InkWell(
            onTap: () {
              Navigator.pushNamed(context, ('/product'),
                  arguments: widget.orderProduct.product);
            },
            child: Image.network(widget.orderProduct.product.imgs,
                width: 100, height: 80, fit: BoxFit.contain),
          ),
          SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.orderProduct.product.name,
                    style: Theme.of(context).textTheme.headline4),
                Text('Price: \$${widget.orderProduct.price}',
                    style: Theme.of(context).textTheme.headline5),
                Text(
                  'Quantity: ${widget.orderProduct.quantity}',
                  style: Theme.of(context).textTheme.headline5,
                ),
                if (widget.orderProduct.refunded == "In Progress")
                  Text(
                    'Refund Requested',
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(color: Colors.orange.shade300),
                  ),
                if (widget.orderProduct.refunded == "True")
                  Text(
                    '\$${widget.orderProduct.price * widget.orderProduct.quantity} Refunded',
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(color: Colors.green.shade300),
                  ),
                if (widget.orderProduct.refunded == "Rejected")
                  Text(
                    'Refund Rejected',
                    style: Theme.of(context)
                        .textTheme
                        .headline5!
                        .copyWith(color: Colors.red.shade300),
                  ),
                if (widget.role.toLowerCase() == "user" &&
                    widget.status.toLowerCase() == "delivered")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(primary: Colors.black),
                        onPressed: () {
                          showDialog(
                            context: context,
                            barrierDismissible:
                                true, // set to false if you want to force a rating
                            builder: (context) => RatingDialog(
                              initialRating: 1.0,
                              // your app's name?
                              title: Text(
                                widget.orderProduct.product.name,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              // encourage your user to leave a high rating?
                              message: Text(
                                'Tap a star to set your rating. Add more description here if you want.',
                                textAlign: TextAlign.center,
                                style: const TextStyle(fontSize: 15),
                              ),
                              // your app's logo?
                              image: Image.network(
                                  widget.orderProduct.product.imgs,
                                  width: 100,
                                  height: 80,
                                  fit: BoxFit.contain),
                              submitButtonText: 'Submit',
                              commentHint: 'Leave A Review',
                              onCancelled: () => print('cancelled'),
                              onSubmitted: (response) async {
                                await _submit(
                                    response.rating, response.comment);
                              },
                            ),
                          );
                        },
                        child: Text('Leave a\nReview'),
                      ),
                      if (widget.orderProduct.refunded.toLowerCase() == "false")
                        ElevatedButton(
                          onPressed: () async {
                            if (isRefundPossible) {
                              await Provider.of<Orders>(context, listen: false)
                                  .requestRefundForProduct(
                                      productId: widget.orderProduct.product.id,
                                      orderId: widget.orderId,
                                      token: authData.token);
                              Navigator.pushNamed(context, '/profile');
                            } else {
                              final snackBar = SnackBar(
                                content: Text(
                                    'More than 30 days passed after your order!'),
                                duration: const Duration(seconds: 4),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                          child: Text('Request\nRefund'),
                          style:
                              ElevatedButton.styleFrom(primary: Colors.black),
                        )
                    ],
                  ),
              ],
            ),
          ),
          SizedBox(width: 10),
        ],
      ),
    );
  }
}
