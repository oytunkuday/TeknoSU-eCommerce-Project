// ignore_for_file: prefer_const_constructors

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teknosu_mobile/providers/providers.dart';

import '../widgets/_widgets.dart';

class ReviewScreen extends StatefulWidget {
  static const String routeName = '/review';
  const ReviewScreen({required this.product, Key? key}) : super(key: key);

  static Route route({required Product product}) {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => ReviewScreen(
              product: product,
            ));
  }

  final Product product;

  @override
  State<ReviewScreen> createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      // Invalid!
      return;
    }
    _formKey.currentState!.save();
    setState(() {
      _isLoading = true;
    });
    try {
      final userData = Provider.of<Auth>(context, listen: false);
      final token = userData.token;
      await Provider.of<Reviews>(context, listen: false)
          .createReviewByProductId(widget.product.id, rating, review, token);
      Navigator.pushNamed(context, "/");
      _formKey.currentState!.reset();
    } catch (error) {
      print(error);
    }
    setState(() {
      _isLoading = false;
    });
  }

  var _isInit = true;
  var _isLoading = false;
  var rating = 0.0;
  var review = '';
  final GlobalKey<FormState> _formKey = GlobalKey();

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Reviews>(context)
          .fetchAndSetReviewsByProductId(widget.product.id)
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
    final reviewData = Provider.of<Reviews>(context);
    final reviews = reviewData.reviewsById;
    return Scaffold(
      bottomNavigationBar: CustomNavBar(),
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
              child: Column(
                children: [
                  CarouselSlider(
                      options: CarouselOptions(
                        aspectRatio: 1.5,
                        viewportFraction: 0.9,
                        enlargeCenterPage: true,
                        enlargeStrategy: CenterPageEnlargeStrategy.height,
                        initialPage: 0,
                        autoPlay: false,
                      ),
                      items: [HeroCarouselCard(imageUrl: widget.product.imgs)]),
                  ProductInfo(product: widget.product),
                  ReviewTile(reviews: reviews),
                  Padding(padding: EdgeInsets.symmetric(vertical: 8)),
                  SectionTitle(title: 'LEAVE A REVIEW'),
                  Container(
                    height: 80,
                    width: MediaQuery.of(context).size.width,
                  )
                  /*Padding(
              padding: kDefaultPadding,
              child: SingleChildScrollView(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: 250,
                      ),
                      Text(widget.product.id),
                      Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: TextFormField(
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'Give a rating',
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                              validator: (value) {
                                if (value == null || value.trim().isEmpty) {
                                  return 'Provide a rating!';
                                } else {
                                  var myRating = double.parse(value);
                                  if (myRating >= 1 && myRating <= 5) {
                                    return null;
                                  } else {
                                    return 'It must be between 1-5.';
                                  }
                                }
                              },
                              onSaved: (value) {
                                if (value != null) {
                                  rating = double.parse(value);
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: TextFormField(
                              decoration: InputDecoration(
                                hintText: 'Give a review',
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black),
                                ),
                              ),
                              onSaved: (value) {
                                if (value != null) {
                                  review = value;
                                }
                              },
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      if (_isLoading)
                        CircularProgressIndicator()
                      else
                        Row(
                          children: [
                            Expanded(
                              flex: 1,
                              child: ElevatedButton(
                                onPressed: _submit,
                                child: Text(
                                  'Submit',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headline3!
                                      .copyWith(color: Colors.white),
                                ),
                                style: ElevatedButton.styleFrom(
                                    primary: Colors.black),
                              ),
                            ),
                          ],
                        ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ),
            ),*/
                ],
              ),
            ),
    );
  }
}
