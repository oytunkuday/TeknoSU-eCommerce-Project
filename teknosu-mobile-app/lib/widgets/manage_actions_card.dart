// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teknosu_mobile/providers/providers.dart';

class ManageActionCard extends StatelessWidget {
  const ManageActionCard({Key? key, required this.title, required this.route})
      : super(key: key);
  final String title;
  final String route;

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
      child: InkWell(
        onTap: () {
          if (authData.isAuth) {
            Navigator.pushNamed(context, route);
          } else {
            final snackBar = SnackBar(
              content: Text('Please login first!'),
              duration: const Duration(seconds: 2),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height / 6,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.black,
          ),
          child: Center(
            child: Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .headline2!
                  .copyWith(color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
