import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:lunch_ordering/components.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../APIs.dart';
import '../constants.dart';
import '../screens/main-screen.dart';
import '../screens/view-history.dart';
import 'Manage.dart';

class FoodProvider extends Manage {
  TextEditingController textFieldController = TextEditingController();
  TextEditingController option1controller = TextEditingController();
  TextEditingController option2controller = TextEditingController();
  TextEditingController option3controller = TextEditingController();
  TextEditingController option4controller = TextEditingController();
  List<Menu> menu = [];
  String token = '';

  DateTime tomorrow = DateTime.now().add(new Duration(days: 1));

  Future getToken() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var tok = sharedPreferences.getString('token');

    token = tok!;
  }

  Future deleteFood(food_id) async {
    await getToken();
    final response = await http.delete(
      Uri.parse(AppURL.Foods),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer" + " " + "$token",
      },
      body: jsonEncode(<String, int>{
        'food_id': food_id,
      }),
    );
  }

  // Future<List<Orders>?> getOrders(context) async {
  //   await getToken();
  //   await getMenuID();
  //   List<Orders>? list;
  //   final queryParams = menuIDx;
  //   String queryString = Uri.parse(queryParams).query;
  //   final uri = Uri.parse(AppURL.Foods).replace(queryParameters: {
  //     'menu_id': menuIDx,
  //   });
  //   final response = await http.get(
  //     uri,
  //     headers: <String, String>{
  //       'Content-Type': 'application/json; charset=UTF-8',
  //       HttpHeaders.authorizationHeader: "Bearer" + " " + "$token",
  //     },
  //   );
  //   if (response.statusCode == 200) {
  //     String data = response.body;
  //     print(data);
  //     var rest = jsonDecode(data)['orders'] as List;
  //     list = rest.map<Orders>((json) => Orders.fromJson(json)).toList();
  //   } else {
  //     showDialog(
  //       context: context,
  //       builder: (BuildContext context) {
  //         return alertDialog(response);
  //       },
  //     );
  //     print(response.statusCode);
  //     print(response);
  //   }
  //   return list;
  // }

  Future getMenuID() async {
    await getToken();
    final response =
        await http.get(Uri.parse(AppURL.getMenu), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: "Bearer" + " " + "$token",
    });

    if (response.statusCode == 200) {
      String data = response.body;
      final int menu_id = jsonDecode(data)['data']['menu']['menu_id'];
      menuIDx = menu_id;
      print('menu: $menuIDx');
    } else {
      print(response.statusCode);
      print(response);
    }
    return menuIDx;
  }

  Future orderFood(context) async {
    await getToken();
    await getMenuID();
    final response = await http.post(
      Uri.parse('https://bsl-foodapp-backend.herokuapp.com/api/order'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer" + " " + "$token",
      },
      body: jsonEncode(<String, dynamic>{
        'menu_id': menuIDx,
        'food_id': selected.toString(),
        'drink_id': "14",
        'comment': textFieldController.text,
      }),
    );
    if (response.statusCode == 202) {
      print(response.body);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(const Radius.circular(10.0))),
            title: Column(
              children: [
                const Icon(Icons.check, color: Colors.green),
              ],
            ),
            content: const Text('Your order has been placed'),
          );
        },
      );
    } else {
      print(response.statusCode);
      print(response.body);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog(response);
        },
      );
    }
  }

  Future<List<Menu>?> fetchFood(context) async {
    await getToken();
    List<Menu>? list;
    final response = await http.get(
      Uri.parse(AppURL.getMenu),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer" + " " + "$token",
      },
    );

    if (response.statusCode == 200) {
      String data = response.body;
      var rest = jsonDecode(data)['data']['menu']['foods'] as List;
      print(rest);
      menu = rest.map<Menu>((json) => Menu.fromJson(json)).toList();
      Navigator.pushNamed(context, '/third');
    } else if (response.statusCode == 401) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
              title: Column(
                children: [
                  const Icon(Icons.cancel, color: Colors.red),
                  Text('Oh no!'),
                ],
              ),
              content: Text('Please Try Again Later'));
        },
      );
      print(response.statusCode);
      print(response);
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog(response);
        },
      );
      print(response.statusCode);
      print(response);
    }
    return list;
  }

  Future<List<Orders>?> getPreviousOrders(context) async {
    await getToken();
    List<Orders>? list;
    final response = await http.get(
      Uri.parse(AppURL.orderMenu),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer" + " " + "$token",
      },
    );

    if (response.statusCode == 200) {
      String data = response.body;
      print(data);
      var rest = jsonDecode(data)['orders'] as List;
      list = rest.map<Orders>((json) => Orders.fromJson(json)).toList();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog(response);
        },
      );
      print(response.statusCode);
      print(response);
    }
    return list;
  }

  Future<List<Menu>?> fetchAllFoods(context) async {
    await getToken();
    List<Menu>? list;
    final response = await http.get(
      Uri.parse(AppURL.Foods),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer" + " " + "$token",
      },
    );

    if (response.statusCode == 200) {
      String data = response.body;

      var rest = jsonDecode(data)['foods'] as List;
      list = rest.map<Menu>((json) => Menu.fromJson(json)).toList();
      notifyListeners();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog(response);
        },
      );
      print(response.statusCode);
      print(response);
    }
    return list;
  }

  Future addMenu(List, context) async {
    await getToken();
    changeStatus(true);
    final response = await http.post(
      Uri.parse('https://bsl-foodapp-backend.herokuapp.com/api/menu'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer" + " " + "$token",
      },
      body: jsonEncode(<String, dynamic>{
        "menu_date": "$tomorrow",
        "foods": List,
        "drinks": [1, 2, 4]
      }),
    );

    if (response.statusCode == 201) {
      String data = response.body;
      print(response.body);
      changeStatus(false);
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Added Successfully'),
            content: Text(response.body),
          );
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
          return alertDialogLogin(response);
        },
      );
    }
  }
}

class Menu {
  int? id;
  String? Option;

  Menu({this.id, this.Option});

  factory Menu.fromJson(Map<String, dynamic> responseData) {
    return Menu(
      id: responseData['id'],
      Option: responseData['name'],
    );
  }
}

class Orders {
  int? id;
  String? food, drink, comment;

  Orders({this.id, this.food, this.drink, this.comment});
  factory Orders.fromJson(Map<String, dynamic> responseData) {
    return Orders(
      id: responseData['id'],
      food: responseData['food'],
      drink: responseData['drink'],
      comment: responseData['comment'],
    );
  }
}
