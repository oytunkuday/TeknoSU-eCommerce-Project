// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teknosu_mobile/providers/providers.dart';
import 'package:teknosu_mobile/widgets/_widgets.dart';

class ManageReviewsScreen extends StatefulWidget {
  static const String routeName = '/manageReviews';
  const ManageReviewsScreen({Key? key}) : super(key: key);

  static Route route() {
    return MaterialPageRoute(
        settings: RouteSettings(name: routeName),
        builder: (_) => ManageReviewsScreen());
  }

  @override
  State<ManageReviewsScreen> createState() => _ManageReviewsScreenState();
}

class _ManageReviewsScreenState extends State<ManageReviewsScreen> {
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

  var _isLoading = false;

  @override
  void didChangeDependencies() async {
    bool isUpdated = Provider.of<Reviews>(context, listen: false).isPatchExist;
    if (isUpdated) {
      setState(() {
        _isLoading = true;
      });
      final userData = Provider.of<Auth>(context, listen: false);
      await Provider.of<Reviews>(context, listen: false)
          .getReviewsByStatus(context, userData.token, 'not reviewed');
      await Provider.of<Reviews>(context, listen: false)
          .getReviewsByStatus(context, userData.token, 'true');
      await Provider.of<Reviews>(context, listen: false)
          .getReviewsByStatus(context, userData.token, 'false');
      await Future.delayed(const Duration(milliseconds: 400), () {});
      Provider.of<Reviews>(context, listen: false).setIsPatchExist(false);
      setState(() {
        _isLoading = false;
      });
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var reviewData = Provider.of<Reviews>(context);
    final authData = Provider.of<Auth>(context);
    return _isLoading
        ? Center(
            child: CircularProgressIndicator(),
          )
        : DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                backgroundColor: Colors.black,
                elevation: 0,
                centerTitle: true,
                bottom: TabBar(
                  tabs: [
                    Tab(child: Text('Pending')),
                    Tab(child: Text('Approved')),
                    Tab(child: Text('Disapproved')),
                  ],
                ),
                title: Container(
                  color: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Text(
                    'Manage Reviews',
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
                  ReviewList(productReviewsList: reviewData.pendingReviews),
                  ReviewList(productReviewsList: reviewData.approvedReviews),
                  ReviewList(productReviewsList: reviewData.disapprovedReviews)
                ],
              ),
            ),
          );
  }
}

class ReviewList extends StatelessWidget {
  const ReviewList({
    Key? key,
    required this.productReviewsList,
  }) : super(key: key);

  final List<ProductReview> productReviewsList;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: productReviewsList.length,
        itemBuilder: (context, index) {
          return Column(
            children: [
              ReviewProductCard(
                product: productReviewsList[index].product,
                review: productReviewsList[index].review,
              ),
              Divider(
                thickness: 1,
              )
            ],
          );
        });
  }
}
