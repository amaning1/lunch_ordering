import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lunch_ordering/providers/Manage.dart';
import '../APIs.dart';
import '../components.dart';

class RegProvider extends Manage {
  final TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey1 = GlobalKey<FormState>(debugLabel: 'signup');
  String token = '';
  String dropDownValue = 'user';
  registerImplementation(BuildContext context) async {
    if (formKey1.currentState!.validate()) {
      changeStatus(true);
      notifyListeners();
      register(context);
    }
  }

  Future addUser(context) async {
    changeStatus(true);
    final String token;
    final response = await http.post(
      Uri.parse(AppURL.Register),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phone_number': numberController.text,
        'password': passwordController.text,
        'type': dropDownValue,
        'name': nameController.text,
      }),
    );

    if (response.statusCode == 201) {
      String data = response.body;
      changeStatus(false);
      notifyListeners();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return alertDialog(context, () {
              Navigator.pop(context);
            }, 'You\'ve Signed Up', "User has been added", 'Exit');
          });
    } else if (response.statusCode == 422) {
      changeStatus(false);
      notifyListeners();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return alertDialog(context, () {
              Navigator.pop(context);
            }, 'Invalid Details', "Please provide valid form details", 'Exit');
          });
    } else {
      changeStatus(false);
      print(response.statusCode);
      print(response.body);
    }
    return null;
  }

  Future register(context) async {
    changeStatus(true);
    final String token;
    final response = await http.post(
      Uri.parse(AppURL.Register),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phone_number': numberController.text,
        'password': passwordController.text,
        'type': "user",
        'name': nameController.text,
      }),
    );

    if (response.statusCode == 201) {
      String data = response.body;
      changeStatus(false);
      notifyListeners();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return alertDialog(context, () {
              Navigator.popAndPushNamed(context, '/signin');
            }, 'You\'ve Signed Up', "Contact your administrators", 'Sign In');
          });
    } else if (response.statusCode == 422) {
      changeStatus(false);
      notifyListeners();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return alertDialog(context, () {
              Navigator.pop(context);
            }, 'Invalid Details', "Please provide valid form details", 'Exit');
          });
    } else {
      changeStatus(false);
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
