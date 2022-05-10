import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:lunch_ordering/shared_preferences.dart';

import '../APIs.dart';
import '../Domain/user.dart';

enum Status {
  LoggedIn,
  NotLoggedIn,
  Registered,
  Registering,
  NotRegistered,
  Authenticating,
  LoggedOut,
}

class AuthProvider extends ChangeNotifier {
  Status _loggedInStatus = Status.NotLoggedIn;
  Status _registered = Status.NotRegistered;

  Status get loggedInStatus => _loggedInStatus;

  set loggedInStatus(Status value) {
    _loggedInStatus = value;
  }

  Status get registered => _registered;

  set registered(Status value) {
    _registered = value;
  }

  Future login(number, password) async {
    final String token;
    return await http.post(
      Uri.parse(AppURL.Login),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'phone_number': number,
        'password': password,
      }),
    );
  }

  Future<User?> register(number, password, name) async {
    final String token;
    final response = await http.post(
      Uri.parse('https://bsl-foodapp-backend.herokuapp.com/api/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, dynamic>{
        'phone_number': number,
        'password': password,
        'type': "1",
        'name': name,
      }),
    );
  }

  static Future<FutureOr> onValue(Response response) async {
    var result;
    final Map<String, dynamic> responseData = json.decode(response.body);
    print(responseData);

    if (response.statusCode == 200) {
      User authUser = User.fromJson(responseData);

      UserPreferences().saveUser(authUser);

      result = {
        'status': true,
        'message': 'User Logged In',
        'data': authUser,
      };
    } else {
      result = {
        'status': false,
        'message': 'User unable to log in',
        'data': responseData,
      };

      print(responseData);
    }
    return result;
  }
}
