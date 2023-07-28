// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teknosu_mobile/config/theme.dart';
import 'package:teknosu_mobile/providers/providers.dart';
import 'package:teknosu_mobile/widgets/_widgets.dart';

class AddCategoryScreen extends StatefulWidget {
  const AddCategoryScreen({Key? key}) : super(key: key);
  static const String routeName = '/addCategory';

  static Route route() {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => AddCategoryScreen());
  }

  @override
  State<AddCategoryScreen> createState() => _AddCategoryScreenState();
}

class _AddCategoryScreenState extends State<AddCategoryScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final Map<String, dynamic> _categoryData = {
    'Name': '',
    'Photo': '',
  };
  var _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context);
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Add Category',
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
                            _categoryData['Name'] = value;
                          }
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: TextFormField(
                        keyboardType: TextInputType.text,
                        decoration: InputDecoration(
                          labelText: 'Photo URL',
                          labelStyle: TextStyle(
                            color: Color(0xFF979797),
                          ),
                          focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Photo URL field cannot be empty';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          if (value != null) {
                            _categoryData['Photo'] = value;
                          }
                        },
                      ),
                    ),
                  ],
                ),
                if (_isLoading)
                  CircularProgressIndicator()
                else
                  Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.black),
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  FocusManager.instance.primaryFocus?.unfocus();
                                  await Provider.of<Categories>(context,
                                          listen: false)
                                      .addNewCategory(
                                          token: authData.token,
                                          name: _categoryData['Name'],
                                          photo: _categoryData['Photo']);
                                  Navigator.pushNamed(
                                      context, '/productManager');
                                }
                              },
                              child: Text(
                                'Add New Category',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline3!
                                    .copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ],
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
