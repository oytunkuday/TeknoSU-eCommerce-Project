// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:teknosu_mobile/providers/providers.dart';

class ReviewTile extends StatelessWidget {
  const ReviewTile({
    Key? key,
    required this.reviews,
  }) : super(key: key);

  final List<Review> reviews;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: ExpansionTile(
        leading: Icon(
          Icons.reviews,
          color: Colors.black,
          size: 20,
        ),
        title: Text(
          'Reviews (${reviews.length})',
          style: Theme.of(context).textTheme.headline3,
        ),
        children: [
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            itemCount: reviews.length,
            itemBuilder: (context, index) {
              return Column(
                children: [
                  ListTile(
                    title: RatingBarIndicator(
                      itemBuilder: (context, _) => Icon(
                        Icons.star,
                        color: Colors.amber,
                      ),
                      direction: Axis.horizontal,
                      rating: double.parse(reviews[index].rating.toString()),
                      itemCount: 5,
                      itemSize: 20,
                    ),
                    subtitle: Text(
                      reviews[index].review,
                      style: Theme.of(context).textTheme.bodyText1,
                    ),
                    tileColor: Colors.grey.withAlpha(30),
                  ),
                  Divider(
                    thickness: 0.5,
                    color: Colors.black,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
