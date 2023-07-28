// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teknosu_mobile/providers/providers.dart';
import 'package:teknosu_mobile/widgets/_widgets.dart';

class ReviewProductCard extends StatefulWidget {
  const ReviewProductCard(
      {Key? key, required this.product, required this.review})
      : super(key: key);

  final Product product;
  final Review review;

  @override
  State<ReviewProductCard> createState() => _ReviewProductCardState();
}

class _ReviewProductCardState extends State<ReviewProductCard> {
  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<Auth>(context);
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          barrierDismissible:
              true, // set to false if you want to force a rating
          builder: (context) => ReviewDialog(
              message: Text(
                widget.review.review,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headline4,
              ),
              image: Image.network(
                widget.product.imgs,
                width: 100,
                height: 80,
                fit: BoxFit.contain,
              ),
              enableComment: false,
              rating: widget.review.rating,
              title: Text(
                widget.product.name,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              approveButtonText:
                  widget.review.approved == "not reviewed" ? 'Approve' : "",
              disapproveButtonText:
                  widget.review.approved == "not reviewed" ? 'Disapprove' : "",
              onApproved: () async {
                if (widget.review.approved == "not reviewed") {
                  await Provider.of<Reviews>(context, listen: false)
                      .patchReview(
                          token: userData.token,
                          reviewId: widget.review.id,
                          status: 'true');
                }
              },
              onDisapproved: () async {
                if (widget.review.approved == "not reviewed") {
                  await Provider.of<Reviews>(context, listen: false)
                      .patchReview(
                          token: userData.token,
                          reviewId: widget.review.id,
                          status: 'false');
                }
              }),
        );
      },
      child: Padding(
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
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.black),
                    onPressed: () {
                      Navigator.pushNamed(context, ('/product'),
                          arguments: widget.product);
                    },
                    child: Text('Go to product'),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
          ],
        ),
      ),
    );
  }
}
