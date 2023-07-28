// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

import '../providers/providers.dart';
import '_widgets.dart';

class ProductDetails extends StatelessWidget {
  const ProductDetails({
    Key? key,
    required this.product,
    required this.reviews,
  }) : super(key: key);

  final Product product;
  final List<Review> reviews;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ExpansionTile(
            childrenPadding: const EdgeInsets.symmetric(horizontal: 10.0),
            title: Text(
              'Product Description',
              style: Theme.of(context).textTheme.headline3,
            ),
            children: [
              ListTile(
                title: Text(
                  product.description,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                tileColor: Colors.grey.withAlpha(30),
                focusColor: Colors.white,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ExpansionTile(
            childrenPadding: const EdgeInsets.symmetric(horizontal: 10.0),
            leading: Icon(
              Icons.info,
              color: Colors.black,
              size: 20,
            ),
            title: Text(
              'About Product',
              style: Theme.of(context).textTheme.headline3,
            ),
            children: [
              ListTile(
                title: Text(
                  'Average Rating: ' + product.ratingsAvg.toString(),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                tileColor: Colors.grey.withAlpha(30),
                focusColor: Colors.white,
              ),
              Divider(
                thickness: 0.5,
                color: Colors.black,
              ),
              ListTile(
                title: Text(
                  'Distributor: ' + product.distributor,
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                tileColor: Colors.grey.withAlpha(30),
                focusColor: Colors.white,
              ),
              Divider(
                thickness: 0.5,
                color: Colors.black,
              ),
              ListTile(
                title: Text(
                  'Stock: ' + product.stocks.toString(),
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                tileColor: Colors.grey.withAlpha(30),
              ),
              Divider(
                thickness: 0.5,
                color: Colors.black,
              ),
              ListTile(
                title: Text(
                  'Warranty Status: ${product.warranty == true ? 'Warranted' : 'Unwarranted'}',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                tileColor: Colors.grey.withAlpha(30),
              ),
            ],
          ),
        ),
        ReviewTile(reviews: reviews),
      ],
    );
  }
}
