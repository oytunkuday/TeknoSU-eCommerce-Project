// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teknosu_mobile/providers/providers.dart';

class CustomAppBar extends StatefulWidget with PreferredSizeWidget {
  final String title;
  final double horizontalPaddingValue;

  const CustomAppBar({
    Key? key,
    required this.title,
    this.horizontalPaddingValue = 20,
  }) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(50.0);
}

class _CustomAppBarState extends State<CustomAppBar> {
  void _showLogoutDialog() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: Text("You Are About to Log Out"),
              content: Text('Are You Sure?'),
              actions: [
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.black),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text("NO")),
                ElevatedButton(
                    style: ElevatedButton.styleFrom(primary: Colors.black),
                    onPressed: () {
                      Provider.of<Auth>(context, listen: false).logout();
                      Navigator.of(context).pop();
                      Navigator.pushNamed(context, '/');
                    },
                    child: Text("YES"))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    var authData = Provider.of<Auth>(context);
    var isAuth = authData.isAuth;
    return AppBar(
      centerTitle: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.black,
        ),
        padding: EdgeInsets.symmetric(
            horizontal: widget.horizontalPaddingValue, vertical: 10),
        child: Text(
          widget.title,
          style: Theme.of(context)
              .textTheme
              .headline2!
              .copyWith(color: Colors.white),
        ),
      ),
      iconTheme: IconThemeData(color: Colors.black),
      actions: [
        IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/wishlist');
            },
            icon: Icon(Icons.favorite)),
        if (!isAuth)
          IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              icon: Icon(Icons.login)),
        if (isAuth)
          IconButton(
              onPressed: () {
                _showLogoutDialog();
              },
              icon: Icon(Icons.logout)),
      ],
    );
  }
}
