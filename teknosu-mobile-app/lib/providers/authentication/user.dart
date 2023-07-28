import 'package:flutter/foundation.dart';

class User with ChangeNotifier {
  final String role;
  final String id;
  final String name;
  final String email;
  final String address;

  User(
      {required this.id,
      required this.name,
      required this.email,
      required this.role,
      this.address = ""});
}
