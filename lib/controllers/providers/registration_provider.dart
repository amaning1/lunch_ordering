import 'dart:convert';
import 'dart:core';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lunch_ordering/controllers/providers/Manage.dart';
import 'package:lunch_ordering/shared_preferences.dart';
import '../../APIs.dart';
import '../../components.dart';

class RegProvider extends Manage {
  final TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final TextEditingController newNameController = TextEditingController();
  TextEditingController newNumberController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  final formKey1 = GlobalKey<FormState>(debugLabel: 'signup');

  String dropDownValue = 'user';

  registerImplementation(BuildContext context) async {
    if (formKey1.currentState!.validate()) {
      changeStatus(true);
      notifyListeners();
      register(context);
    }
  }

  Future addUser(context) async {
    await getToken();
    changeStatus(true);
    final response = await http.post(
      Uri.parse(AppURL.User),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer" " " "$token",
      },
      body: jsonEncode(<String, String>{
        'phone_number': newNumberController.text,
        'password': newPasswordController.text,
        'type': dropDownValue,
        'name': newNameController.text,
      }),
    );

    if (response.statusCode == 201) {
      changeStatus(false);
      notifyListeners();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return alertDialog(context, () {
              Navigator.pop(context);
            }, 'New User Added', "User has been added", 'Exit');
          });
    } else if (response.statusCode == 422) {
      print(response.body);
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
    }
    return null;
  }

  Future register(context) async {
    changeStatus(true);
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
    }
    return null;
  }

  void clearForm() {
    numberController.text = '';
    passwordController.text = '';
  }
}
