// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:teknosu_mobile/providers/providers.dart';

class ProductInfo extends StatelessWidget {
  const ProductInfo({
    Key? key,
    required this.product,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 90,
            alignment: Alignment.bottomCenter,
            color: Colors.black.withAlpha(50),
          ),
          Container(
            margin: const EdgeInsets.all(5.0),
            width: MediaQuery.of(context).size.width,
            height: 80,
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 3,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            product.brand + ' ' + product.name,
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(color: Colors.white),
                          ),
                          if (product.stocks == 0)
                            Text(
                              'Out Of Stock',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(color: Colors.red.shade500),
                            ),
                          if (product.stocks != 0 && product.stocks <= 5)
                            Text(
                              "Last ${product.stocks} product!",
                              style: Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(color: Colors.orange.shade500),
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                  ),
                  VerticalDivider(
                    width: 2,
                    thickness: 2,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '\$${product.price}',
                          style: product.discount == 0
                              ? Theme.of(context)
                                  .textTheme
                                  .headline4!
                                  .copyWith(color: Colors.white)
                              : Theme.of(context).textTheme.headline6!.copyWith(
                                  color: Colors.white,
                                  decoration: TextDecoration.lineThrough),
                        ),
                        if (product.discount != 0)
                          Text(
                            '\$${(product.newPrice).toStringAsFixed(1)}',
                            style: Theme.of(context)
                                .textTheme
                                .headline4!
                                .copyWith(color: Colors.red.shade500),
                          )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
