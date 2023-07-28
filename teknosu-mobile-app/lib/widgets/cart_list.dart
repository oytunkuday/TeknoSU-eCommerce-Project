import 'package:flutter/material.dart';
import 'package:teknosu_mobile/providers/providers.dart';
import 'package:teknosu_mobile/widgets/_widgets.dart';

class CartList extends StatelessWidget {
  const CartList({
    Key? key,
    required this.userCartProducts,
    required this.cartProducts,
    this.isSummary = false,
  }) : super(key: key);

  final List<Product> userCartProducts;
  final List<CartProduct> cartProducts;
  final bool isSummary;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.55,
      child: ListView.builder(
          padding: const EdgeInsets.all(8),
          itemCount: userCartProducts.length,
          itemBuilder: (BuildContext context, int index) {
            return CartProductCard(
              isSummary: isSummary,
              product: userCartProducts[index],
              quantity: (() {
                var list = cartProducts.where((element) =>
                    element.productId == userCartProducts[index].id);
                if (list.isNotEmpty) {
                  return list.first.quantity;
                }
                return 0;
              })(),
            );
          }),
    );
  }
}
