// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teknosu_mobile/providers/providers.dart';

import '../widgets/order_list.dart';

class ManageOrdersScreen extends StatefulWidget {
  static const String routeName = '/manageOrders';
  const ManageOrdersScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => ManageOrdersScreen());
  }

  @override
  State<ManageOrdersScreen> createState() => _ManageOrdersScreenState();
}

class _ManageOrdersScreenState extends State<ManageOrdersScreen> {
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

  var _isInit = true;
  var _isLoading = false;
  @override
  void didChangeDependencies() async {
    bool isUpdated = Provider.of<Orders>(context, listen: false).isPatchExist;
    if (isUpdated || _isInit) {
      setState(() {
        _isLoading = true;
      });
      final userData = Provider.of<Auth>(context, listen: false);
      await Provider.of<Orders>(context, listen: false)
          .getOrdersByStatus(context, userData.token, 'Processing');
      await Provider.of<Orders>(context, listen: false)
          .getOrdersByStatus(context, userData.token, 'In-Transit');
      await Provider.of<Orders>(context, listen: false)
          .getOrdersByStatus(context, userData.token, 'Delivered');
      await Provider.of<Orders>(context, listen: false)
          .getOrdersByStatus(context, userData.token, 'Cancelled');
      await Future.delayed(const Duration(milliseconds: 400), () {});
      _isInit = false;
      Provider.of<Orders>(context, listen: false).setIsPatchExist(false);
      setState(() {
        _isLoading = false;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var orderData = Provider.of<Orders>(context);
    var authData = Provider.of<Auth>(context);
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : DefaultTabController(
            length: 4,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black,
                elevation: 0,
                centerTitle: true,
                bottom: TabBar(
                  tabs: [
                    Tab(child: Text('In-Process')),
                    Tab(child: Text('In-Transit')),
                    Tab(child: Text('Delivered')),
                    Tab(child: Text('Cancelled')),
                  ],
                ),
                title: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    'Manage Orders',
                    style: Theme.of(context).textTheme.headline2,
                  ),
                ),
                actions: [
                  if (!authData.isAuth)
                    IconButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        icon: Icon(Icons.login)),
                  if (authData.isAuth)
                    IconButton(
                        onPressed: () {
                          _showLogoutDialog();
                        },
                        icon: Icon(Icons.logout)),
                ],
              ),
              body: TabBarView(
                children: [
                  OrderList(orderList: orderData.processingOrders),
                  OrderList(orderList: orderData.inTransitOrders),
                  OrderList(orderList: orderData.deliveredOrders),
                  OrderList(orderList: orderData.cancelledOrders),
                ],
              ),
            ),
          );
  }
}
