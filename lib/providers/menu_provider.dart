import 'package:flutter/material.dart';
import '../Domain/menu.dart';
import 'Manage.dart';
import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:lunch_ordering/components.dart';
import 'package:http/http.dart' as http;
import '../APIs.dart';
import '../Domain/ChipData.dart';
import '../Domain/allMenus.dart';
import '../Domain/oldOrders.dart';
import '../constants.dart';
import '../shared_preferences.dart';

class MenuProvider extends Manage {
  List<Food> menu = [];
  List<Datum> allMenu = [];
  List<OldOrders> list = [];
  List<Drink> drinks = [];
  List<ChipData> foodChips = [];
  List<ChipData> drinkChips = [];
  List<int> foodIDS = [];
  List<int> drinkIDS = [];
  int menuIDx = 0;
  late OldOrders oldOrders;
  var food;

  Future<List<Datum>?> fetchPreviousMenus(context) async {
    await getToken();
    List<Datum>? list;

    final response = await http.get(
      Uri.parse(AppURL.allMenu),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer" + " " + "$token",
      },
    );

    if (response.statusCode == 200) {
      String data = response.body;
      var rest = jsonDecode(data)['data'] as List;

      print(rest);
      final allMenus = allMenusFromJson(data);
      allMenu = allMenus.data;
      print(allMenu);
      // getFoods();
      // for (int i = 0; i < allMenu.length; i++) {
      //   menu = allMenu[i].foods;
      //   for (int i = 0; i < menu.length; i++) {
      //     food = menu[i].foodName;
      //     print(food);
      //   }
      //   //print(food);
      //   print('------------------------------------------');
      // }

      Navigator.pushNamed(context, '/allMenus');
    } else if (response.statusCode == 401) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog(
              context, null, 'Uh Oh', 'We\'ve run into a problem', '');
        },
      );
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog(context, () {
            logout(context);
          }, 'Uh Oh', 'We\'ve run into a problem', 'Logout');
        },
      );
    }
    return list;
  }

  List<String> getFoods() {
    for (int i = 0; i < allMenu.length; i++) {
      menu = allMenu[i].foods;
      for (int i = 0; i < menu.length; i++) {
        food.add(menu[i].foodName);
      }
    }
    return food;
  }

  Future addMenu(foodList, drinkList, context) async {
    await getToken();
    changeStatus(true);
    final response = await http.post(
      Uri.parse('https://bsl-foodapp-backend.herokuapp.com/api/menu'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer" + " " + "$token",
      },
      body: jsonEncode(<String, dynamic>{
        "menu_date": "$selectedDate",
        "foods_id": foodList,
        "drinks_id": drinkList
      }),
    );

    if (response.statusCode == 201) {
      String data = response.body;
      print(response.body);
      changeStatus(false);
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog(context, () {
            Navigator.pushReplacementNamed(context, '/allMenus');
          }, 'Menu Added', 'The menu has been added successfully',
              'View Menus');
        },
      );
    } else {
      changeStatus(false);
      notifyListeners();
      print(response.statusCode);
      print(response.body);
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog(context, () {
            Navigator.popAndPushNamed(context, '/allMenus');
          }, 'Error ', 'There was a problem adding your menu. Try again later',
              'View Menus');
        },
      );
    }
  }
}
