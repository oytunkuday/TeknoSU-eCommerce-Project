import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:teknosu_mobile/models/http_exception.dart';
import 'package:teknosu_mobile/providers/providers.dart';

import 'user.dart';

class Auth with ChangeNotifier {
  String baseUrl = 'http://10.0.2.2:3000/api/v1/';
  String _token = "";

  bool get isAuth {
    return token != "";
  }

  String get token {
    return _token;
  }

  User _user = User(id: "", name: "", email: "", role: "");

  User get user {
    return _user;
  }

  bool _isPatchExist = true;
  void setIsPatchExist(bool status) {
    _isPatchExist = status;
  }

  bool get isPatchExist {
    return _isPatchExist;
  }

  Future<void> setHomeAddress(
      {required String name,
      required String address,
      required String zipCode,
      required String city,
      required String country,
      required String userid,
      required String token}) async {
    String encodedAddress =
        name + "\t" + address + "\t" + zipCode + "\t" + city + "\t" + country;
    final url = Uri.parse("${baseUrl}users/$userid");
    final response = await http.patch(url,
        body: json.encode(
          {
            'address': encodedAddress,
          },
        ),
        headers: <String, String>{
          "Authorization": "Bearer $token",
          'Content-Type': 'application/json; charset=UTF-8',
        });
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    setIsPatchExist(true);
    print(extractedData);
    notifyListeners();
  }

  String decodedAddress(String address) {
    List<String> addressList = address.split("\t");
    String name = addressList[0];
    String myAddress = addressList[1];
    String zipCode = addressList[2];
    String city = addressList[3];
    String country = addressList[4];
    return name +
        "\n" +
        myAddress +
        "\t" +
        zipCode +
        "\t" +
        city +
        "/" +
        country;
  }

  Future<void> signup(String? name, String? email, String? password,
      String? passwordConfirm) async {
    final url = Uri.parse("${baseUrl}users/signup");
    try {
      final response = await http.post(url,
          body: json.encode(
            {
              'name': name,
              'email': email,
              'password': password,
              'passwordConfirm': passwordConfirm
            },
          ),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      final responseData = json.decode(response.body);
      if (responseData['error'] != null) {
        throw HttpException(responseData['message']);
      }
      _token = responseData["token"];
      User loadeduser = User(
        id: responseData['data']['user']['_id'],
        name: responseData['data']['user']['name'],
        email: responseData['data']['user']['email'],
        role: responseData['data']['user']['role'],
        address: responseData['data']['user']['address'] ?? "",
      );
      _user = loadeduser;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  Future<void> getCurrentUserByToken(String token) async {
    final url = Uri.parse("${baseUrl}users/current");
    final response = await http.get(url, headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      'Authorization': "Bearer $token"
    });
    final responseData = json.decode(response.body) as Map<String, dynamic>;
    User loadeduser = User(
      id: responseData['user']['_id'],
      name: responseData['user']['name'],
      email: responseData['user']['email'],
      role: responseData['user']['role'],
      address: responseData['user']['address'] ?? "",
    );
    _user = loadeduser;
    notifyListeners();
  }

  Future<void> login(String? email, String? password) async {
    final url = Uri.parse("${baseUrl}users/login");
    try {
      final response = await http.post(url,
          body: json.encode(
            {'email': email, 'password': password},
          ),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
          });
      final responseData = json.decode(response.body);

      if (responseData['error'] != null) {
        throw HttpException(responseData['message']);
      }
      _token = responseData["token"];
      User loadeduser = User(
        id: responseData['data']['user']['_id'],
        name: responseData['data']['user']['name'],
        email: responseData['data']['user']['email'],
        role: responseData['data']['user']['role'],
        address: responseData['data']['user']['address'] ?? "",
      );
      _user = loadeduser;
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }

  void logout() {
    _token = "";
    _user = User(id: "", name: "", email: "", role: "", address: "");
  }
}

/*  signupRequest() async {
    //final token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjYyNjA1YmJlMjIyNDYzNjc4MWMzNWU2MSIsImlhdCI6MTY1MDQ4MzE1NiwiZXhwIjoxNjU4MjU5MTU2fQ.D2hXa0qQjvLp6_VKsmgs06q257xF_6cJlzIpPJ8zQTQ";

    try {
        body: jsonEncode({"name": name, "email": mail, "password": pass, "passwordConfirm": confirmPass}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          //'Authorization': 'Bearer $token'
        },
      );

      if (response.statusCode != 201) {
        throw "Signup Failed";
      }

      final body = json.decode(response.body);

      Navigator.pushNamed(context, '/');
      print("Successfully connected");
    } catch (e) {
      print(e);
      Navigator.pushNamed(context, '/aliparlakci');
      print("something happened");*/
