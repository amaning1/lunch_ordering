import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lunch_ordering/providers/Manage.dart';
import 'package:lunch_ordering/screens/loading-screen.dart';
import 'package:lunch_ordering/screens/main-screen.dart';
import 'package:lunch_ordering/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../APIs.dart';
import '../Domain/user.dart';
import '../components.dart';
import '../screens/menu-loading-screen.dart';
import '../screens/menu/all-menus.dart';
import '../screens/sign-in.dart';

class AuthProvider extends Manage {
  bool isAuthenticating = false;
  final TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  late User user;

  loadUserNumberPassword() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var phone_number = prefs.getString('phone_number');
      var password = prefs.getString('password');
      var rememberMe = prefs.getBool("remember_me");

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
      String? phoneNumber = prefs.getString('phone_number');
      String? password = prefs.getString('password');
      notifyListeners();
      print(phoneNumber);
      print(password);

      if (password != null && phoneNumber != null) {
        print('autoLogin0');
        numberController.text = phoneNumber;
        passwordController.text = password;
        print('autoLogin1');
        notifyListeners();
        print('autoLogin2');
        login(context);
      } else {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => const SignIn()));
      }
    } catch (e) {
      Navigator.pushNamed(context, '/signin');
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
    print('login0');
    if (response.statusCode == 202) {
      String data = response.body;
      changeStatus(false);
      var rest = jsonDecode(data)['data'];
      user = User.fromJson(rest);
      saveToken(user.token);
      saveUserDetails(user.phone_number, passwordController.text);

      if (user.type == "chef" || user.type == "admin") {
        saveToken(user.token);
        if (user.type == "admin") {}
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const MenuLoadingScreen()));
        clearForm();
      } else {
        saveToken(user.token);
        Navigator.pushReplacement(context,
            MaterialPageRoute(builder: (context) => const SplashScreen()));
        clearForm();
      }
    } else {
      changeStatus(false);

      Navigator.pushReplacementNamed(context, '/signin');
    }
    return null;
  }

  void clearForm() {
    numberController.text = '';
    passwordController.text = '';
  }
}
