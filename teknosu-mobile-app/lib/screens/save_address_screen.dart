// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teknosu_mobile/config/theme.dart';
import 'package:teknosu_mobile/providers/providers.dart';
import 'package:teknosu_mobile/widgets/_widgets.dart';

class SaveAddressScreen extends StatefulWidget {
  const SaveAddressScreen({Key? key}) : super(key: key);
  static const String routeName = '/saveAddress';

  static Route route() {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => SaveAddressScreen());
  }

  @override
  State<SaveAddressScreen> createState() => _SaveAddressScreenState();
}

class _SaveAddressScreenState extends State<SaveAddressScreen> {
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
        title: 'New Address',
      ),
      bottomNavigationBar: CustomNavBar(),
      body: Padding(
        padding: kDefaultPadding,
        child: SingleChildScrollView(
          child: Form(
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
                          style:
                              ElevatedButton.styleFrom(primary: Colors.black),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              FocusManager.instance.primaryFocus?.unfocus();
                              await Provider.of<Auth>(context, listen: false)
                                  .setHomeAddress(
                                      name: _userData['Name'],
                                      address: _userData["Address"],
                                      city: _userData["City"],
                                      country: _userData["Country"],
                                      zipCode: _userData["Zip Code"],
                                      userid: authData.user.id,
                                      token: authData.token);
                              Navigator.pushNamed(context, '/profile');
                            }
                          },
                          child: Text(
                            'Save',
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
        ),
      ),
    );
  }
}
