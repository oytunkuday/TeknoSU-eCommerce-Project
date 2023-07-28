// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teknosu_mobile/providers/providers.dart';

import '../widgets/_widgets.dart';

class ProductScreen extends StatefulWidget {
  static const String routeName = '/product';
  const ProductScreen({required this.product, Key? key}) : super(key: key);

  static Route route({required Product product}) {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => ProductScreen(
              product: product,
            ));
  }

  final Product product;

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  int stockData = 0;
  var _isInit = true;
  var _isLoading = false;

  Future<void> _addToCart(String prodId, String token, String name) async {
    try {
      await Provider.of<CartProducts>(context, listen: false)
          .addToCart(prodId, token, 1, name);
      await Provider.of<CartProducts>(context, listen: false)
          .getCartProductsWithToken(token);
    } catch (error) {
      print(error);
    }
  }

  Future<void> _addToWishlist(
      {required String productId,
      required String token,
      required bool isAuth,
      required List<WishlistProduct> wishlistProducts}) async {
    bool isAlreadyExist = false;
    wishlistProducts.forEach((element) {
      if (element.productId == productId) {
        isAlreadyExist = true;
      }
    });
    if (!isAuth) {
      final snackBar = SnackBar(
        content: Text('Please login for adding product to wishlist!'),
        duration: const Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else if (isAlreadyExist) {
      final snackBar = SnackBar(
        content: Text('This product exists on your wishlist!'),
        duration: const Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } else {
      try {
        Provider.of<WishlistProducts>(context, listen: false)
            .addToWishlist(token: token, productId: productId);
        final snackBar = SnackBar(
          content: Text('Added to wishlist!'),
          duration: const Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      } catch (error) {
        print(error);
      }
    }
  }

  @override
  void didChangeDependencies() async {
    bool _isUpdated = Provider.of<Products>(context).isPatchExist;
    if (_isInit || _isUpdated) {
      setState(() {
        _isLoading = true;
      });
      // await Future.delayed(const Duration(milliseconds: 100), () {});
      await Provider.of<Reviews>(context)
          .fetchAndSetReviewsByProductId(widget.product.id)
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
      await Provider.of<Products>(context, listen: false)
          .getProductById(widget.product.id);
    }
    _isInit = false;
    Provider.of<Products>(context, listen: false).setIsPatchExist(false);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final reviewsData = Provider.of<Reviews>(context);
    final reviews = reviewsData.reviewsById;
    final authData = Provider.of<Auth>(context);
    final wishlistData = Provider.of<WishlistProducts>(context);
    final product = Provider.of<Products>(context).product;

    return Scaffold(
      appBar: CustomAppBar(title: product.brand + ' ' + product.name),
      bottomNavigationBar: BottomAppBar(
        color: Colors.black,
        child: Container(
          height: 70,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.share,
                  color: Colors.white,
                ),
              ),
              IconButton(
                onPressed: () {
                  _addToWishlist(
                      productId: product.id,
                      token: authData.token,
                      isAuth: authData.isAuth,
                      wishlistProducts: wishlistData.wishlistProducts);
                },
                icon: Icon(
                  Icons.favorite,
                  color: Colors.white,
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(primary: Colors.white),
                onPressed: () {
                  if (product.stocks == 0) {
                    final snackBar = SnackBar(
                      content: Text('Out of Stock, you cannot add to cart!'),
                      duration: const Duration(seconds: 3),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else if (!authData.isAuth) {
                    final snackBar = SnackBar(
                      content: Text('Please login to add product to cart!'),
                      duration: const Duration(seconds: 3),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else if (product.status == "passive") {
                    final snackBar = SnackBar(
                      content: Text('This product is no longer available!'),
                      duration: const Duration(seconds: 3),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    _addToCart(product.id, authData.token, product.name);
                    final snackBar = SnackBar(
                      content: Text('Added to cart!'),
                      duration: const Duration(seconds: 2),
                    );
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  }
                },
                child: Text(
                  'ADD TO CART',
                  style: Theme.of(context).textTheme.headline3,
                ),
              )
            ],
          ),
        ),
      ),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView(children: [
              CarouselSlider(
                  options: CarouselOptions(
                    aspectRatio: 1.5,
                    viewportFraction: 0.9,
                    enlargeCenterPage: true,
                    enlargeStrategy: CenterPageEnlargeStrategy.height,
                    initialPage: 0,
                    autoPlay: false,
                  ),
                  items: [HeroCarouselCard(imageUrl: product.imgs)]),
              ProductInfo(product: product),
              if (product.status == "active")
                ProductDetails(product: product, reviews: reviews),
              if (product.status == "passive")
                WarningCard(info: "This Product is No Longer Available"),
              if (authData.user.role == "productManager" &&
                  product.status == 'active')
                Form(
                  key: _formKey,
                  child: Row(
                    children: [
                      Text(
                        'New Stock: ',
                        style: Theme.of(context).textTheme.headline4,
                      ),
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.6,
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          child: TextFormField(
                            keyboardType: TextInputType.number,
                            decoration: InputDecoration(
                              hintText: 'New Stock',
                              labelStyle: TextStyle(
                                color: Color(0xFF979797),
                              ),
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.black),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Name field cannot be empty!';
                              } else {
                                return null;
                              }
                            },
                            onSaved: (value) {
                              if (value != null) {
                                stockData =
                                    int.tryParse(value) ?? product.stocks;
                              }
                            },
                          ),
                        ),
                      ),
                      ElevatedButton(
                          style:
                              ElevatedButton.styleFrom(primary: Colors.black),
                          onPressed: () async {
                            if (_formKey.currentState!.validate()) {
                              _formKey.currentState!.save();
                              _formKey.currentState!.reset();
                              FocusManager.instance.primaryFocus?.unfocus();
                              Provider.of<Products>(context, listen: false)
                                  .patchProductStock(
                                      id: product.id,
                                      token: authData.token,
                                      newStock: stockData);
                              final snackBar = SnackBar(
                                content: Text(
                                    'Stock of the product updated as $stockData.'),
                                duration: const Duration(seconds: 2),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            }
                          },
                          child: (Text('Save')))
                    ],
                  ),
                ),
              if (authData.user.role == "productManager")
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: ElevatedButton(
                    onPressed: () async {
                      if (product.status == 'active') {
                        await Provider.of<Products>(context, listen: false)
                            .deleteProduct(
                                token: authData.token, id: product.id);
                      } else {
                        await Provider.of<Products>(context, listen: false)
                            .activateProduct(
                                token: authData.token, id: product.id);
                      }
                    },
                    child: product.status == 'active'
                        ? Text('Remove')
                        : Text('Activate'),
                    style: product.status == 'active'
                        ? ElevatedButton.styleFrom(primary: Colors.red.shade500)
                        : ElevatedButton.styleFrom(
                            primary: Colors.green.shade500),
                  ),
                )
            ]),
    );
  }
}
