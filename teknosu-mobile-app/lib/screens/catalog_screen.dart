// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teknosu_mobile/providers/providers.dart';

import '../widgets/_widgets.dart';

class CatalogScreen extends StatefulWidget {
  static const String routeName = '/catalog';
  const CatalogScreen({required this.category, Key? key}) : super(key: key);

  static Route route({required Category category}) {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (context) => CatalogScreen(category: category));
  }

  final Category category;

  @override
  State<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends State<CatalogScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  var _isInit = true;
  var _isLoading = false;
  String searchedValue = "";
  String sortData = "Price Ascending";

  void _search() {}

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context)
          .fetchAndSetProducts(
              category: widget.category.name,
              sort: sortData,
              search: searchedValue)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final userData = Provider.of<Auth>(context);
    var productsData = Provider.of<Products>(context);
    var products = productsData.items;
    var activeProducts =
        products.where((product) => product.status == "active").toList();
    return Scaffold(
      appBar: CustomAppBar(title: widget.category.name),
      bottomNavigationBar: CustomNavBar(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width * 0.25,
                      child: Form(
                        key: _formKey,
                        child: TextFormField(
                          decoration: InputDecoration(
                              hintText: 'Search product name...'),
                          onSaved: (value) {
                            if (value != null) {
                              searchedValue = value;
                            } else {
                              searchedValue = "";
                            }
                          },
                        ),
                      ),
                    ),
                    IconButton(
                        onPressed: () {
                          setState(() {
                            _formKey.currentState!.save();
                            FocusManager.instance.primaryFocus?.unfocus();
                            Provider.of<Products>(context, listen: false)
                                .fetchAndSetProducts(
                                    category: widget.category.name,
                                    sort: sortData,
                                    search: searchedValue);
                          });
                        },
                        icon: Icon(Icons.search)),
                    SortingMenu(
                      value: sortData,
                      onChanged: (value) async {
                        setState(() {
                          sortData = value ?? 'Price Ascending';
                        });
                        await Provider.of<Products>(context, listen: false)
                            .fetchAndSetProducts(
                                category: widget.category.name,
                                sort: sortData,
                                search: searchedValue);
                      },
                    ),
                  ],
                ),
                Expanded(
                  child: GridView.builder(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8.0, vertical: 16.0),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2, childAspectRatio: 1.15),
                      itemCount: products.length,
                      itemBuilder: (BuildContext context, int index) {
                        return Center(
                          child: ProductCard(
                            product: userData.user.role == "productManager"
                                ? products[index]
                                : activeProducts[index],
                            widthFactor: 2.2,
                          ),
                        );
                      }),
                ),
              ],
            ),
    );
  }
}
