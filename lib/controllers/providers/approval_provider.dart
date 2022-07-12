import 'package:flutter/material.dart';
import '/models/allUsers.dart';
import 'Manage.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:core';
import 'package:lunch_ordering/components.dart';
import 'package:http/http.dart' as http;
import '/APIs.dart';
import '/models/new-user.dart';
import '/shared_preferences.dart';

class ApprovalProvider extends Manage {
  List<AllUsers> allUsers = [];
  List<AllUsers>? allChefs = [];
  List<String> chefNames = [];
  List<NewUser> newUsers = [];
  //String dropDownValue = chefNames.first;

  Future<List<NewUser>?> getAllApprovalRequests(context) async {
    await getToken();
    final response = await http
        .get(Uri.parse(AppURL.approvalRequests), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: "Bearer" " " "$token",
    });
    String data = response.body;

    if (response.statusCode == 200) {
      var rest = jsonDecode(data)['data'] as List;
      newUsers = rest.map<NewUser>((json) => NewUser.fromJson(json)).toList();
    } else {
      newUsers = [];
    }
    return newUsers;
  }

  Future approveUser(userId, context) async {
    changeStatus(true);
    await getToken();
    final response = await http.put(
      Uri.parse(AppURL.approveUser),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer" " " "$token",
      },
      body: jsonEncode(<String, int>{
        'user_id': userId,
      }),
    );
    if (response.statusCode == 200) {
      String data = response.body;
      var message = jsonDecode(data)['message'];
      changeStatus(false);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog(context, () {
            Navigator.pop(context);
          }, 'Success', message, 'Exit');
        },
      );
    } else {
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
        HttpHeaders.authorizationHeader: "Bearer" " " "$token",
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
      //changeMenu(true);
      var users = jsonDecode(data)['data'] as List;
      allUsers =
          users.map<AllUsers>((json) => AllUsers.fromJson(json)).toList();
      for (int i = 0; i < allUsers.length; i++) {
        allChefs = allUsers.where((element) => element.type == 'chef').toList();
      }
      for (int i = 0; i < allChefs!.length; i++) {
        chefNames.add(allChefs![i].name);
      }
    } else if (response.statusCode == 401) {
    } else {
      //changeMenu(false);
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
