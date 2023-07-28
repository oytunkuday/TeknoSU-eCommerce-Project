// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teknosu_mobile/config/theme.dart';
import 'package:teknosu_mobile/providers/providers.dart';
import 'package:teknosu_mobile/widgets/_widgets.dart';

class CheckOutScreen extends StatefulWidget {
  const CheckOutScreen({Key? key}) : super(key: key);
  static const String routeName = '/checkout';

  static Route route() {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => CheckOutScreen());
  }

  @override
  State<CheckOutScreen> createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final Map<String, dynamic> _userData = {
    'Name': '',
    'Address': '',
    'Zip Code': 0,
    'City': '',
    'Country': '',
  };
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final cartProductsData = Provider.of<CartProducts>(context);
    final authData = Provider.of<Auth>(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Checkout',
      ),
      bottomNavigationBar: CustomNavBar(),
      body: Padding(
        padding: kDefaultPadding,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (authData.user.address != "")
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: ListTile(
                    onTap: () {
                      Provider.of<OrderInfoInstance>(context, listen: false)
                          .setOrderInfo(
                        name: authData.user.address.split("\t")[0],
                        address: authData.user.address.split("\t")[1],
                        city: authData.user.address.split("\t")[3],
                        country: authData.user.address.split("\t")[4],
                        zipCode:
                            int.parse(authData.user.address.split("\t")[2]),
                      );
                      Navigator.pushNamed(context, '/creditCard');
                    },
                    title: Center(
                      child: Text(
                        "Send to Home Address",
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ),
                    tileColor: Colors.grey.withAlpha(30),
                  ),
                ),
              if (authData.user.address != "")
                Row(children: [
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(left: 10.0, right: 20.0),
                        child: Divider(
                          color: Colors.black,
                          height: 36,
                        )),
                  ),
                  Text(
                    "OR",
                    style: Theme.of(context).textTheme.headline3,
                  ),
                  Expanded(
                    child: Container(
                        margin: const EdgeInsets.only(left: 20.0, right: 10.0),
                        child: Divider(
                          color: Colors.black,
                          height: 36,
                        )),
                  ),
                ]),
              Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: TextFormField(
                            decoration: InputDecoration(
                                labelText: 'Name',
                                labelStyle: TextStyle(
                                  color: Color(0xFF979797),
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                )),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Name field cannot be empty!';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              if (value != null) {
                                _userData['Name'] = value;
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'Address',
                              labelStyle: TextStyle(
                                color: Color(0xFF979797),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Address field cannot be empty';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              if (value != null) {
                                _userData['Address'] = value;
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              labelText: 'Zip Code',
                              labelStyle: TextStyle(
                                color: Color(0xFF979797),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Zip Code field cannot be empty';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              if (value != null) {
                                _userData['Zip Code'] = value;
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'City',
                              labelStyle: TextStyle(
                                color: Color(0xFF979797),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'City field cannot be empty';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              if (value != null) {
                                _userData['City'] = value;
                              }
                            },
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: TextFormField(
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                              labelText: 'Country',
                              labelStyle: TextStyle(
                                color: Color(0xFF979797),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Country field cannot be empty';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              if (value != null) {
                                _userData['Country'] = value;
                              }
                            },
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 240),
                    if (_isLoading)
                      CircularProgressIndicator()
                    else
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.black),
                              onPressed: () {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  Provider.of<OrderInfoInstance>(context,
                                          listen: false)
                                      .setOrderInfo(
                                    name: _userData['Name'],
                                    address: _userData["Address"],
                                    city: _userData["City"],
                                    country: _userData["Country"],
                                    zipCode: int.parse(_userData["Zip Code"]),
                                  );
                                  Navigator.pushNamed(context, '/creditCard');
                                }
                              },
                              child: Text(
                                'Go to Payment',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      ),
                    SizedBox(
                      height: 20,
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
