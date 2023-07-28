// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teknosu_mobile/config/app_router.dart';
import 'package:teknosu_mobile/config/theme.dart';
import 'package:teknosu_mobile/providers/providers.dart';

import 'providers/authentication/auth.dart';
import 'screens/_screens.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: Auth()),
          ChangeNotifierProvider.value(value: Products()),
          ChangeNotifierProvider.value(value: Categories()),
          ChangeNotifierProvider.value(value: Reviews()),
          ChangeNotifierProvider.value(value: Orders()),
          ChangeNotifierProvider.value(value: CartProducts()),
          ChangeNotifierProvider.value(value: CreditCardInstance()),
          ChangeNotifierProvider.value(value: OrderInfoInstance()),
          ChangeNotifierProvider.value(value: WishlistProducts()),
        ],
        child: MaterialApp(
          title: 'TeknoSU',
          theme: theme(),
          onGenerateRoute: AppRouter.onGenerateRoute,
          initialRoute: HomeScreen.routeName,
          home: HomeScreen(),
        ));
  }
}
