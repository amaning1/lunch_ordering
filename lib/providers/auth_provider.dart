import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lunch_ordering/providers/Manage.dart';
import 'package:lunch_ordering/providers/food_providers.dart';
import 'package:lunch_ordering/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../APIs.dart';
import '../Domain/user.dart';
import '../components.dart';
import '../constants.dart';

class AuthProvider extends Manage {
  bool isAuthenticating = false;
  final TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late User user;
  Future loadUserNumberPassword() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var phone_number = prefs.getString('phone_number');
      var password = prefs.getString('password');
      var rememberMe = prefs.getBool("remember_me");

      print(rememberMe);
      print(phone_number);
      print(password);

      if (rememberMe == true) {
        numberController.text = phone_number!;
        passwordController.text = password!;
      }
    } catch (e) {
      print(e);
    }
  }

  Future autoLogIn(context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      print('1');
      var phoneNumber = prefs.getString('phone_number');
      print(phoneNumber);
      print('2');
      var password = prefs.getString('password');
      notifyListeners();

      if (phoneNumber != null) {
        numberController.text = phoneNumber;
        passwordController.text = password!;
        notifyListeners();
        login(context);
      } else {
        Navigator.pushReplacementNamed(context, '/signin');
      }
    } catch (e) {
      print(e);
    }
  }

  Future forgotPassword(context) async {
    final response = await http.post(
      Uri.parse(AppURL.forgotPassword),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phone_number': numberController.text,
      }),
    );

    if (response.statusCode == 201) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return alertDialog(context, () {
              Navigator.pop(context);
            }, 'Password Reset Requested', "Please contact your administrator",
                'Exit');
          });
    }
  }

  Future login(context) async {
    changeStatus(true);

    final response = await http.post(
      Uri.parse(AppURL.Login),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phone_number': numberController.text,
        'password': passwordController.text,
      }),
    );
    if (response.statusCode == 202) {
      String data = response.body;
      print(data);
      changeStatus(false);

      var rest = jsonDecode(data)['data'];
      user = User.fromJson(rest);
      saveToken(user.token);
      saveUserDetails(user.phone_number, passwordController.text);
      print(user.phone_number);
      print('100');
      print(passwordController.text);
      clearForm();

      if (user.type == "chef" || user.type == "admin") {
        saveToken(user.token);
        Navigator.pushNamed(context, '/allMenus');
      } else {
        saveToken(user.token);
        Navigator.pushNamed(context, '/splash');
      }
    } else {
      String data = response.body;
      var message = jsonDecode(data)['message'];

      changeStatus(false);
      notifyListeners();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return alertDialog(context, () {
              Navigator.pop(context);
            }, 'Invalid Login', message.toString(), 'Exit');
          });

      print(response.statusCode);
      print(response.body);
    }
    return null;
  }

  void clearForm() {
    numberController.text = '';
    passwordController.text = '';
  }
}
