// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:teknosu_mobile/providers/providers.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final double widthFactor;
  final double leftPosition;
  final bool isWishlist;

  const ProductCard({
    required this.product,
    this.widthFactor = 2.5,
    this.leftPosition = 5,
    this.isWishlist = false,
    Key? key,
  }) : super(key: key);

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  Future<void> _addToCart(String prodId, String token, String name) async {
    await Provider.of<CartProducts>(context, listen: false)
        .addToCart(prodId, token, 1, name);
    await Provider.of<CartProducts>(context, listen: false)
        .getCartProductsWithToken(token);
  }

  Future<void> _removeFromWishlist(
      {required String productId, required String token}) async {
    try {
      await Provider.of<WishlistProducts>(context, listen: false)
          .removeFromWishlist(token: token, productId: productId);
      await Provider.of<WishlistProducts>(context, listen: false)
          .getWishlistProductsWithToken(token);
      final snackBar = SnackBar(
        content: Text('Removed from wishlist!'),
        duration: const Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } catch (error) {
      print(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context);
    final token = authData.token;
    final double widthValue =
        MediaQuery.of(context).size.width / widget.widthFactor;
    return InkWell(
      onTap: () {
        Navigator.pushNamed(context, '/product', arguments: widget.product);
      },
      child: Stack(
        children: [
          Container(
            width: widthValue,
            height: 150,
            child: Image.network(
              widget.product.imgs,
              fit: BoxFit.contain,
            ),
          ),
          Positioned(
            top: 60,
            left: widget.leftPosition,
            child: Container(
              width: widthValue - 10 - widget.leftPosition,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(50),
              ),
            ),
          ),
          Positioned(
            top: 65,
            left: widget.leftPosition + 5,
            child: Container(
              width: widthValue - 20 - widget.leftPosition,
              height: 90,
              decoration: BoxDecoration(
                color: Colors.black,
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.product.name,
                            style: Theme.of(context)
                                .textTheme
                                .headline5!
                                .copyWith(color: Colors.white),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            '\$${widget.product.price} ',
                            style: widget.product.discount == 0
                                ? Theme.of(context)
                                    .textTheme
                                    .headline6!
                                    .copyWith(color: Colors.white)
                                : Theme.of(context)
                                    .textTheme
                                    .bodyText2!
                                    .copyWith(
                                        color: Colors.white,
                                        decoration: TextDecoration.lineThrough),
                          ),
                          if (widget.product.discount != 0)
                            Text(
                              '\$${(widget.product.newPrice).toStringAsFixed(1)}',
                              style: Theme.of(context)
                                  .textTheme
                                  .headline6!
                                  .copyWith(color: Colors.red.shade500),
                            ),
                          RatingBarIndicator(
                            itemBuilder: (context, _) => Icon(
                              Icons.star,
                              color: Colors.amber,
                            ),
                            direction: Axis.horizontal,
                            rating: double.parse(
                                widget.product.ratingsAvg.toString()),
                            itemCount: 5,
                            itemSize: 14,
                          ),
                          if (widget.product.stocks == 0)
                            Text(
                              'Out of Stock',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(color: Colors.red.shade500),
                              overflow: TextOverflow.ellipsis,
                            ),
                          if (widget.product.stocks != 0 &&
                              widget.product.stocks <= 5)
                            Text(
                              "Last ${widget.product.stocks} product!",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1!
                                  .copyWith(color: Colors.orange.shade500),
                              overflow: TextOverflow.ellipsis,
                            ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        onPressed: () {
                          if (widget.product.stocks == 0) {
                            final snackBar = SnackBar(
                              content:
                                  Text('Out of Stock, you cannot add to cart!'),
                              duration: const Duration(seconds: 2),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else if (!authData.isAuth) {
                            final snackBar = SnackBar(
                              content:
                                  Text('Please login to add product to cart!'),
                              duration: const Duration(seconds: 3),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            _addToCart(widget.product.id, authData.token,
                                widget.product.name);
                            final snackBar = SnackBar(
                              content: Text('Added to cart!'),
                              duration: const Duration(seconds: 2),
                            );
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          }
                        },
                        icon: Icon(
                          Icons.add_circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    widget.isWishlist
                        ? Expanded(
                            child: IconButton(
                              onPressed: () {
                                _removeFromWishlist(
                                    productId: widget.product.id,
                                    token: authData.token);
                              },
                              icon: Icon(Icons.delete, color: Colors.white),
                            ),
                          )
                        : SizedBox()
                  ],
                ),
              ),
            ),
          ),
          if (widget.product.status == 'passive')
            Container(
              width: widthValue - 5 - widget.leftPosition,
              height: 145,
              decoration: BoxDecoration(
                color: Colors.black.withAlpha(90),
              ),
              child: Center(
                  child: Text(
                'This product is no longer available!',
                style: Theme.of(context)
                    .textTheme
                    .headline3!
                    .copyWith(color: Colors.red),
              )),
            ),
        ],
      ),
    );
  }
}
