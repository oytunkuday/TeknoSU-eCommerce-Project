// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class WarningCard extends StatelessWidget {
  const WarningCard({
    Key? key,
    required this.info,
  }) : super(key: key);

  final String info;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Stack(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            height: 90,
            alignment: Alignment.bottomCenter,
            color: Colors.black.withAlpha(50),
          ),
          Container(
            margin: const EdgeInsets.all(5.0),
            width: MediaQuery.of(context).size.width,
            height: 80,
            color: Colors.black,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    flex: 1,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            info,
                            style:
                                Theme.of(context).textTheme.headline4!.copyWith(
                                      color: Colors.red.shade500,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
