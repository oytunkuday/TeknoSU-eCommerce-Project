// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teknosu_mobile/config/theme.dart';
import 'package:teknosu_mobile/providers/providers.dart';
import 'package:teknosu_mobile/widgets/_widgets.dart';

class AddProductScreen extends StatefulWidget {
  const AddProductScreen({Key? key}) : super(key: key);
  static const String routeName = '/addProduct';

  static Route route() {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => AddProductScreen());
  }

  @override
  State<AddProductScreen> createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();

  final Map<String, dynamic> _ProductData = {
    'Name': '',
    'Brand': '',
    'Category': '',
    'Description': '',
    'Distributor': '',
    'Cost': '',
    'Price': '',
    'Stocks': '',
    'Warranty': '',
    'Photo': '',
  };
  var _isLoading = false;
  List<DropdownMenuItem<String>> warrantyOptions =
      ['True', 'False'].map<DropdownMenuItem<String>>((String value) {
    return DropdownMenuItem<String>(
      value: value.toLowerCase(),
      child: Text(value),
    );
  }).toList();
  @override
  Widget build(BuildContext context) {
    final authData = Provider.of<Auth>(context);
    final categoryData = Provider.of<Categories>(context);
    List<DropdownMenuItem<String>> categoryOptions = categoryData.categories
        .where((category) => category.status == "active")
        .toList()
        .map<DropdownMenuItem<String>>((Category category) {
      return DropdownMenuItem<String>(
        value: category.name,
        child: Text(category.name),
      );
    }).toList();
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Add Product',
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
                            _ProductData['Name'] = value;
                          }
                        },
                      ),
                    ), //Name
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Brand',
                            labelStyle: TextStyle(
                              color: Color(0xFF979797),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            )),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Brand field cannot be empty!';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          if (value != null) {
                            _ProductData['Brand'] = value;
                          }
                        },
                      ),
                    ), //Brand
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Text(
                              "Category: ",
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: DropdownButton(
                                isExpanded: true,
                                items: categoryOptions,
                                onChanged: (value) {
                                  setState(() {
                                    _ProductData['Category'] = value;
                                  });
                                },
                                value: _ProductData['Category'] != ''
                                    ? _ProductData['Category']
                                    : categoryOptions[0].value,
                                icon: const Icon(Icons.arrow_drop_down)),
                          ),
                        ],
                      ),
                    ), //category
                    Divider(
                      thickness: 1,
                      color: Colors.black.withAlpha(120),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Description',
                            labelStyle: TextStyle(
                              color: Color(0xFF979797),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            )),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Description field cannot be empty!';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          if (value != null) {
                            _ProductData['Description'] = value;
                          }
                        },
                      ),
                    ), //Description
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: TextFormField(
                        decoration: InputDecoration(
                            labelText: 'Distributor',
                            labelStyle: TextStyle(
                              color: Color(0xFF979797),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            )),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Distributor field cannot be empty!';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          if (value != null) {
                            _ProductData['Distributor'] = value;
                          }
                        },
                      ),
                    ), //Distributor
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Cost',
                            labelStyle: TextStyle(
                              color: Color(0xFF979797),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            )),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Cost field cannot be empty!';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          if (value != null) {
                            _ProductData['Cost'] = value;
                          }
                        },
                      ),
                    ), //Cost
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Price',
                            labelStyle: TextStyle(
                              color: Color(0xFF979797),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            )),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Price field cannot be empty!';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          if (value != null) {
                            _ProductData['Price'] = value;
                          }
                        },
                      ),
                    ), //Price
                    Padding(
                      padding: EdgeInsets.symmetric(vertical: 5),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                            labelText: 'Stocks',
                            labelStyle: TextStyle(
                              color: Color(0xFF979797),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black),
                            )),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Stocks field cannot be empty!';
                          } else {
                            return null;
                          }
                        },
                        onSaved: (value) {
                          if (value != null) {
                            _ProductData['Stocks'] = value;
                          }
                        },
                      ),
                    ), //Stocks
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 5.0),
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10.0),
                            child: Text(
                              "Warranty: ",
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: DropdownButton(
                                isExpanded: true,
                                items: warrantyOptions,
                                onChanged: (value) {
                                  setState(() {
                                    _ProductData['Warranty'] = value;
                                  });
                                },
                                value: _ProductData['Warranty'] != ''
                                    ? _ProductData['Warranty']
                                    : warrantyOptions[0].value,
                                icon: const Icon(Icons.arrow_drop_down)),
                          ),
                        ],
                      ),
                    ), //warranty
                    Divider(
                      thickness: 1,
                      color: Colors.black.withAlpha(120),
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
                            _ProductData['Photo'] = value;
                          }
                        },
                      ),
                    ), //Photo Url
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
                                  Product product = Product(
                                      id: '',
                                      name: _ProductData['Name'],
                                      brand: _ProductData['Brand'],
                                      category: _ProductData['Category'],
                                      description: _ProductData['Description'],
                                      distributor: _ProductData['Distributor'],
                                      price:
                                          double.parse(_ProductData['Price']),
                                      ratingsQuantity: 0,
                                      ratingsAvg: 0,
                                      stocks: int.parse(_ProductData['Stocks']),
                                      warranty:
                                          _ProductData['Warranty'] == 'true'
                                              ? true
                                              : false,
                                      recommended: true,
                                      popular: true,
                                      imgs: _ProductData['Photo'],
                                      discount: 0,
                                      newPrice:
                                          double.parse(_ProductData['Price']),
                                      cost: double.parse(_ProductData['Cost']),
                                      status: 'active');
                                  await Provider.of<Products>(context,
                                          listen: false)
                                      .addProduct(product, authData.token);
                                  Navigator.pushNamed(
                                      context, '/productManager');
                                }
                              },
                              child: Text(
                                'Add New Product',
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
