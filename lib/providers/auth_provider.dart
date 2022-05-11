import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lunch_ordering/providers/Manage.dart';
import 'package:lunch_ordering/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../APIs.dart';
import '../components.dart';
import '../constants.dart';

class AuthProvider extends Manage {
  bool isAuthenticating = false;
  TextEditingController numberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

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
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var phone_number_pref = prefs.getString('phone_number');
    var password_pref = prefs.getString('password');
    print('sup');
    if (phone_number_pref != null) {
      CircularProgressIndicator();

      numberController.text = phone_number_pref;
      passwordController.text = password_pref!;

      login(context);
    } else {
      CircularProgressIndicator();
      Navigator.pushNamedAndRemoveUntil(context, '/signin', (route) => false);
    }
  }

  LoginImplementation(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      changeStatus(true);
      saveUserDetails(numberController.text, passwordController.text);
      login(context);
    }
  }

  Future login(context) async {
    //isAuthenticating = true;
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

      final String token = jsonDecode(data)['data']['token'];
      final String name = jsonDecode(data)['data']['user']['name'];
      final String phone_number =
          jsonDecode(data)['data']['user']['phone_number'];
      final int type = jsonDecode(data)['data']['user']['type'];
      final int status = jsonDecode(data)['data']['user']['status'];

      // isAuthenticating = false;
      changeStatus(false);
      print(token + name + phone_number);
      print(numberController.text);
      print(passwordController.text);
      print(type + status);
      saveToken(token);

      if (type == 2 || type == 1) {
        saveToken(token);
        Navigator.pushNamed(context, '/fourth');
      } else {
        saveToken(token);
        Navigator.pushNamed(context, '/third');
      }
    } else {
      changeStatus(false);
      // isAuthenticating = false;
      notifyListeners();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog(response);
        },
      );
      print(response.statusCode);
      print(response.body);
    }
    return null;
  }
}
