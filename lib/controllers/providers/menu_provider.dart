import 'package:flutter/material.dart';
import 'Manage.dart';
import 'dart:io';
import 'dart:convert';
import 'dart:core';
import 'package:lunch_ordering/components.dart';
import 'package:http/http.dart' as http;
import '../../APIs.dart';
import '../../models/ChipData.dart';
import '../../models/allMenus.dart';
import '../../models/oldOrders.dart';
import '../../constants.dart';
import '../../shared_preferences.dart';

class MenuProvider extends Manage {
  List<Food> menu = [];
  List<Datum> allMenu = [];
  List<OldOrders> list = [];
  List<Drink> drinks = [];
  List<ChipData> foodChips = [];
  List<ChipData> drinkChips = [];
  List<ChipData> chefChips = [];
int? selectedIndex;
  List<int> foodIDS = [];
  List<int> chefIDS = [];


  List<int> drinkIDS = [];
  int menuIDx = 0;
  late OldOrders oldOrders;


  void deleteFoodChip(int id) {
    chefChips.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void removeChef(id) {
    chefIDS.remove(id);
    deleteFoodChip(id);
  }


  void addChef(menu, index, selectedIndex) {
    chefChips.add(ChipData(id: menu[index].id!, name: menu[index].Option!));
    chefIDS.add(menu[index].id!);
    selectedIndex = index;
  }

  Future<List<Datum>?> fetchPreviousMenus(context) async {
    await getToken();
    List<Datum>? list;

    final response = await http.get(
      Uri.parse(AppURL.allMenu),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer" " " "$token",
      },
    );

    if (response.statusCode == 200) {
      String data = response.body;
      final allMenus = allMenusFromJson(data);
      allMenu = allMenus.data;

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

  Future addMenuAdmin(chefID, foodList, drinkList, context) async {
    await getToken();
    changeStatus(true);
    final response = await http.post(
      Uri.parse('https://bsl-foodapp-backend.herokuapp.com/api/menu'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer" " " "$token",
      },
      body: jsonEncode(<String, dynamic>{
        "menu_date": "$selectedDate",
        "foods_id": foodList,
        "drinks_id": drinkList,
        "chef_id": chefID,
      }),
    );

    if (response.statusCode == 201) {
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
      print(response.body);
      notifyListeners();
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

  Future addMenu(foodList, drinkList, context) async {
    await getToken();
    changeStatus(true);
    final response = await http.post(
      Uri.parse('https://bsl-foodapp-backend.herokuapp.com/api/menu'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer" " " "$token",
      },
      body: jsonEncode(<String, dynamic>{
        "menu_date": "$selectedDate",
        "foods_id": foodList,
        "drinks_id": drinkList
      }),
    );

    if (response.statusCode == 201) {
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
