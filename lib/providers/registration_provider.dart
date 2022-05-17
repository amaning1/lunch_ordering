import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lunch_ordering/providers/Manage.dart';
import 'package:lunch_ordering/providers/food_providers.dart';
import 'package:lunch_ordering/screens/sign-in.dart';

import 'package:lunch_ordering/shared_preferences.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../APIs.dart';
import '../components.dart';
import '../constants.dart';

class RegProvider extends Manage {
  final TextEditingController nameController = TextEditingController();
  TextEditingController numberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  final formKey1 = GlobalKey<FormState>();

  registerImplementation(BuildContext context) async {
    if (formKey1.currentState!.validate()) {
      changeRegisterStatus(true);
      notifyListeners();
      register(context);
    }
  }

  Future register(context) async {
    changeRegisterStatus(true);
    final String token;
    final response = await http.post(
      Uri.parse(AppURL.Register),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phone_number': numberController.text,
        'password': passwordController.text,
        'type': "1",
        'name': nameController.text,
      }),
    );

    if (response.statusCode == 201) {
      String data = response.body;
      changeRegisterStatus(false);
      notifyListeners();
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              title: Text('Thank you for registering', style: KAlertHeader),
              insetPadding: EdgeInsets.symmetric(vertical: 240),
              content: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Our administrators will get back to you',
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        child: Text(
                          'Sign in now',
                          style: KAlertButton,
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignIn()),
                          );
                        },
                      ),
                    ],
                  ),
                ],
              ),
            );
            ;
          });
    } else {
      changeRegisterStatus(false);
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
