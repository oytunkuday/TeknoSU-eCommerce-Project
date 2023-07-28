// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:teknosu_mobile/providers/providers.dart';

class HeroCarouselCard extends StatelessWidget {
  final Category? category;
  final String? imageUrl;

  const HeroCarouselCard({Key? key, this.category, this.imageUrl})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (this.imageUrl == null) {
          Navigator.pushNamed(context, '/catalog', arguments: category);
        }
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 5.0, vertical: 20.0),
        child: ClipRRect(
          borderRadius: BorderRadius.all(Radius.circular(5.0)),
          child: Stack(
            children: <Widget>[
              Image.network(imageUrl == null ? category!.imageUrl : imageUrl!,
                  fit: BoxFit.contain, width: 1000.0),
              Positioned(
                bottom: 0.0,
                left: 0.0,
                right: 0.0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color.fromARGB(200, 0, 0, 0),
                        Color.fromARGB(0, 0, 0, 0)
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
                  child: Text(imageUrl == null ? category!.name : '',
                      style: category != null && category!.status == "active"
                          ? Theme.of(context)
                              .textTheme
                              .headline2!
                              .copyWith(color: Colors.white)
                          : Theme.of(context).textTheme.headline2!.copyWith(
                              color: Colors.grey.shade700,
                              decoration: TextDecoration.lineThrough)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
