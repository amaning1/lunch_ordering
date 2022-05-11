import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../APIs.dart';
import '../screens/main-screen.dart';

class FoodProvider extends ChangeNotifier {
  TextEditingController textFieldController = TextEditingController();
  TextEditingController option1controller = TextEditingController();
  TextEditingController option2controller = TextEditingController();
  TextEditingController option3controller = TextEditingController();
  TextEditingController option4controller = TextEditingController();

  String token = '';

  DateTime tomorrow = DateTime.now().add(new Duration(days: 1));
  // _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: _selectedDate,
  //     firstDate: DateTime(2022),
  //     lastDate: DateTime(2023),
  //   );
  //   if (picked != null && picked != _selectedDate)
  //     setState(() {
  //       _selectedDate = picked;
  //     });
  // }

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

  Future getOrders(menu_id) async {
    await getToken();
    final queryParams = menu_id;
    String queryString = Uri.parse(queryParams).query;
    final uri = Uri.parse(AppURL.Foods).replace(queryParameters: {
      'menu_id': menu_id,
    });
    final response = await http.get(
      uri,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer" + " " + "$token",
      },
    );
  }

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
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Column(
              children: [
                const Icon(Icons.cancel, color: Colors.red),
                Text('Error code' + ' ' + response.statusCode.toString()),
              ],
            ),
            content: Text(response.body),
          );
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
      list = rest.map<Menu>((json) => Menu.fromJson(json)).toList();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                const Icon(Icons.cancel, color: Colors.red),
                Text('Error code fetch food' +
                    ' ' +
                    response.statusCode.toString()),
              ],
            ),
            content: Text(response.body),
          );
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
      print(rest);
      list = rest.map<Menu>((json) => Menu.fromJson(json)).toList();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                const Icon(Icons.cancel, color: Colors.red),
                Text('Error code fetch food' +
                    ' ' +
                    response.statusCode.toString()),
              ],
            ),
            content: Text(response.body),
          );
        },
      );
      print(response.statusCode);
      print(response);
    }
    return list;
  }

  Future addMenu() async {
    final response = await http.post(
      Uri.parse('https://bsl-foodapp-backend.herokuapp.com/api/menu'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer" + " " + "$token",
      },
      body: jsonEncode(<String, dynamic>{
        "menu_date": tomorrow,
        "foods": [
          int.parse(option1controller.text),
          int.parse(option2controller.text),
          int.parse(option3controller.text),
          int.parse(option4controller.text),
        ],
        "drinks": [1, 2, 4]
      }),
    );

    if (response.statusCode == 201) {
      String data = response.body;
      print(response.body);
      return AlertDialog(
        title: Text('Added Successfully'),
        content: Text(response.body),
      );
    } else {
      print(response.statusCode);
      print(response.body);
      return AlertDialog(
        title: Text('Error code' + response.statusCode.toString()),
        content: Text(response.body),
      );
    }
  }
}
