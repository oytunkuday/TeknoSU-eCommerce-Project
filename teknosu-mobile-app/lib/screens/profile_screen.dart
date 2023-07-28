// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teknosu_mobile/providers/providers.dart';
import 'package:teknosu_mobile/widgets/_widgets.dart';

import '../widgets/_widgets.dart';

class ProfileScreen extends StatefulWidget {
  static const String routeName = '/profile';
  const ProfileScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => ProfileScreen());
  }

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var _isInit = true;
  var _isLoading = false;

  Future<void> _cancelOrder(String token, String orderId) async {
    await Provider.of<Orders>(context, listen: false).changeOrderStatusById(
        token: token, orderId: orderId, newStatus: 'Cancelled');
  }

  @override
  void didChangeDependencies() async {
    bool _isUpdatedOrder = Provider.of<Orders>(context).isPatchExist;
    bool _isUpdatedUser = Provider.of<Auth>(context).isPatchExist;
    if (_isInit || _isUpdatedOrder || _isUpdatedUser) {
      setState(() {
        _isLoading = true;
      });
      final userData = Provider.of<Auth>(context, listen: false);
      final user = userData.user;
      if (user.id != "") {
        await Provider.of<Orders>(context, listen: false)
            .getOrdersByUserId(context, user.id);
        await Provider.of<Auth>(context, listen: false)
            .getCurrentUserByToken(userData.token);
        _isInit = false;
        Provider.of<Orders>(context, listen: false).setIsPatchExist(false);
        Provider.of<Auth>(context, listen: false).setIsPatchExist(false);
        setState(() {
          _isLoading = false;
        });
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<Auth>(context);
    final user = userData.user;
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: CustomAppBar(title: 'Profile'),
        bottomNavigationBar: CustomNavBar(),
        body: userData.isAuth
            ? (_isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: ExpansionTile(
                            childrenPadding:
                                const EdgeInsets.symmetric(horizontal: 10.0),
                            leading: Icon(
                              Icons.info,
                              color: Colors.black,
                              size: 20,
                            ),
                            title: Text(
                              'Account Information',
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            children: [
                              ListTile(
                                title: Text(
                                  'Name: ' + user.name,
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
                                  'E-mail: ' + user.email,
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
                                  'ID: ' + user.id,
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
                                  'Role: ' + user.role,
                                  style: Theme.of(context).textTheme.bodyText1,
                                ),
                                tileColor: Colors.grey.withAlpha(30),
                              ),
                              Divider(
                                thickness: 0.5,
                                color: Colors.black,
                              ),
                              if (user.address != "")
                                ListTile(
                                  title: Text(
                                    'Address: ' +
                                        Provider.of<Auth>(context)
                                            .decodedAddress(user.address),
                                    style:
                                        Theme.of(context).textTheme.bodyText1,
                                  ),
                                  tileColor: Colors.grey.withAlpha(30),
                                ),
                              if (user.address != "")
                                Divider(
                                  thickness: 0.5,
                                  color: Colors.black,
                                ),
                              ListTile(
                                onTap: () {
                                  Navigator.pushNamed(context, '/saveAddress');
                                },
                                title: Center(
                                  child: Text(
                                    user.address == ""
                                        ? 'Add Home Address'
                                        : "Change Home Address",
                                    style:
                                        Theme.of(context).textTheme.headline4,
                                  ),
                                ),
                                tileColor: Colors.grey.withAlpha(30),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: ExpansionTile(
                            leading: Icon(
                              Icons.reviews,
                              color: Colors.black,
                              size: 20,
                            ),
                            title: Text(
                              'Orders',
                              style: Theme.of(context).textTheme.headline3,
                            ),
                            children: [
                              ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: orderData.orders.length,
                                itemBuilder: (context, index) {
                                  return Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 20),
                                    child: ExpansionTile(
                                      leading: Icon(
                                        Icons.reviews,
                                        color: Colors.black,
                                        size: 20,
                                      ),
                                      title: Text(
                                        '${orderData.orders[index].createdAt.month}.${orderData.orders[index].createdAt.day}.${orderData.orders[index].createdAt.year} (${orderData.orders[index].status})',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline3,
                                      ),
                                      children: [
                                        if (orderData.orders[index].status ==
                                            "Processing")
                                          ElevatedButton.icon(
                                            onPressed: () async {
                                              _cancelOrder(userData.token,
                                                  orderData.orders[index].id);
                                            },
                                            icon: Icon(Icons.cancel_outlined),
                                            label: Text('Cancel Order'),
                                            style: ElevatedButton.styleFrom(
                                                primary: Colors.black),
                                          ),
                                        SingleChildScrollView(
                                          child: ListView.builder(
                                            shrinkWrap: true,
                                            scrollDirection: Axis.vertical,
                                            itemCount: orderData
                                                .orders[index].products.length,
                                            itemBuilder: (context2, index2) {
                                              return Column(
                                                children: [
                                                  OrderProductCard(
                                                    orderDate: orderData
                                                        .orders[index]
                                                        .createdAt,
                                                    orderId: orderData
                                                        .orders[index].id,
                                                    orderProduct: orderData
                                                        .orders[index]
                                                        .products[index2],
                                                    status: orderData
                                                        .orders[index].status,
                                                    role: 'User',
                                                  ),
                                                  Divider(
                                                    thickness: 1,
                                                  )
                                                ],
                                              );
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        if (userData.isAuth &&
                            userData.user.role == "productManager")
                          GestureDetector(
                            onPanUpdate: (details) {
                              if (details.delta.dx < 0) {
                                Navigator.pushNamed(context, '/productManager');
                              }
                            },
                            child: Container(
                                margin: EdgeInsets.all(5.0),
                                width: MediaQuery.of(context).size.width,
                                height: 50,
                                decoration: BoxDecoration(
                                  color: Colors.black,
                                ),
                                child: Center(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Icon(
                                        Icons.arrow_back,
                                        color: Colors.white,
                                      ),
                                      Text(
                                        'Swipe left to switch product manager mode',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headline5!
                                            .copyWith(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                )),
                          ),
                      ],
                    ),
                  ))
            : NotLoggedInButton());
  }
}
