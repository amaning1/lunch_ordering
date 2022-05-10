import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:lunch_ordering/screens/admin-page.dart';
import 'package:lunch_ordering/screens/main-screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'components.dart';

class AppURL {
  static const String baseURL = 'https://bsl-foodapp-backend.herokuapp.com/api';
  static const String Login = baseURL + '/login';
  static const String Register = baseURL + '/register';
  static const String getMenu = baseURL + '/menu?menu_date=2022-02-25';
  static const String orderMenu = baseURL + '/order';
}

// Future getToken() async {
//   final SharedPreferences sharedPreferences =
//       await SharedPreferences.getInstance();
//   var tok = sharedPreferences.getString('token');
//
//   token = tok!;
// }
