import 'package:flutter/material.dart';
import '../Domain/allChefs.dart';
import '../Domain/allUsers.dart';
import '../Domain/menu.dart';
import 'Manage.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:intl/intl.dart';
import 'package:lunch_ordering/components.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lunch_ordering/screens/menu/all-menus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../APIs.dart';
import '../Domain/new-user.dart';
import '../shared_preferences.dart';
import 'Manage.dart';

class ApprovalProvider extends Manage {
  List<AllUsers> allUsers = [];
  List<AllUsers>? allChefs = [];
  List<String> chefNames = [];

  Future<List<NewUser>?> getAllApprovalRequests(context) async {
    await getToken();
    List<NewUser>? list;
    final response = await http
        .get(Uri.parse(AppURL.approvalRequests), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: "Bearer" + " " + "$token",
    });
    String data = response.body;

    if (response.statusCode == 200) {
      print(data);
      var rest = jsonDecode(data)['data'] as List;

      list = rest.map<NewUser>((json) => NewUser.fromJson(json)).toList();
    } else {
      var message = jsonDecode(data)['message'];

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog(context, () {
            Navigator.popAndPushNamed(context, '/addMenu');
          }, 'Error', message, 'Exit');
        },
      );
      print(response.statusCode);
      print(response);
    }
    return list;
  }

  Future approveUser(userId) async {
    changeStatus(true);
    await getToken();
    final response = await http.put(
      Uri.parse(AppURL.approveUser),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer" + " " + "$token",
      },
      body: jsonEncode(<String, int>{
        'user_id': userId,
      }),
    );
    if (response.statusCode == 200) {
      changeStatus(false);
    }
  }

  Future denyUser(userId) async {
    changeStatus(true);
    await getToken();
    final response = await http.put(
      Uri.parse(AppURL.denyUser + '?user_id=' + userId),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer" + " " + "$token",
      },
    );
    if (response.statusCode == 200) {
      changeStatus(false);
    }
  }

  Future<List<AllUsers>?> getAllUsers(context) async {
    await getToken();
    final response = await http.get(
      Uri.parse(AppURL.allUsers),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer" " " + token!,
      },
    );

    if (response.statusCode == 200) {
      String data = response.body;
      changeMenu(true);
      var users = jsonDecode(data)['data'] as List;
      allUsers =
          users.map<AllUsers>((json) => AllUsers.fromJson(json)).toList();
      for (int i = 0; i < allUsers.length; i++) {
        allChefs = allUsers.where((element) => element.type == 'chef').toList();
      }
      for (int i = 0; i < allChefs!.length; i++) {
        chefNames.add(allChefs![i].name);
      }
      print(chefNames);
    } else if (response.statusCode == 401) {
    } else {
      changeMenu(false);
      print(response);
      print(response.statusCode);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog(context, () {
            logout(context);
          }, 'Uh Oh', 'We\'ve run into a problem', 'Logout');
        },
      );
    }
    return allUsers;
  }
}
