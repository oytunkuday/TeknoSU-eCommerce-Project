// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:teknosu_mobile/widgets/_widgets.dart';

class ProductManagerScreen extends StatefulWidget {
  const ProductManagerScreen({Key? key}) : super(key: key);
  static const String routeName = '/productManager';
  static Route route() {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => ProductManagerScreen());
  }

  @override
  State<ProductManagerScreen> createState() => _ProductManagerScreenState();
}

class _ProductManagerScreenState extends State<ProductManagerScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Product Manager',
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ManageActionCard(title: 'MANAGE REVIEWS', route: '/manageReviews'),
            ManageActionCard(title: 'MANAGE ORDERS', route: '/manageOrders'),
            ManageActionCard(title: 'ADD PRODUCT', route: '/addProduct'),
            ManageActionCard(title: 'ADD CATEGORY', route: '/addCategory'),
            ManageActionCard(
              title: "MANAGE CATEGORY",
              route: '/manageCategory',
            ),
          ],
        ),
      ),
    );
  }
}
