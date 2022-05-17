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
import '../components.dart';
import '../constants.dart';

class AuthProvider extends Manage {
  bool isAuthenticating = false;
  final TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey2 = GlobalKey<FormState>();

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
      print(numberController.text);
      print(passwordController.text);
      login(context);
    } else {
      CircularProgressIndicator();
      Navigator.pushNamedAndRemoveUntil(context, '/signin', (route) => false);
    }
  }

  LoginImplementation(BuildContext context) async {
    if (formKey2.currentState!.validate()) {
      changeStatus(true);
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
      final String type = jsonDecode(data)['data']['user']['type'];
      final String status = jsonDecode(data)['data']['user']['status'];

      // isAuthenticating = false;
      changeStatus(false);
      print(token + name + phone_number);
      print(numberController.text);
      print(passwordController.text);
      print(type);
      saveToken(token);
      saveUserDetails(numberController.text, passwordController.text);
      clearForm();

      if (type == "chef" || type == "admin") {
        saveToken(token);
        Navigator.pushNamed(context, '/fourth');
      } else {
        saveToken(token);
        Navigator.pushNamed(context, '/splash');
      }
    } else {
      changeStatus(false);
      // isAuthenticating = false;
      notifyListeners();
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialogLogin(response);
        },
      );
      Navigator.pushNamed(context, '/signin');
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
