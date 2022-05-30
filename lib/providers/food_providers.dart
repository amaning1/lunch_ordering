import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:lunch_ordering/Domain/user.dart';
import 'package:lunch_ordering/components.dart';
import 'package:http/http.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../APIs.dart';
import '../Domain/ChipData.dart';
import '../Domain/drinks.dart';
import '../Domain/foods.dart';
import '../Domain/menu.dart';
import '../Domain/new-user.dart';
import '../Domain/orders.dart';
import '../constants.dart';
import '../screens/main-screen.dart';
import '../screens/view-history.dart';
import '../shared_preferences.dart';
import 'Manage.dart';

class FoodProvider extends Manage {
  TextEditingController textFieldController = TextEditingController();
  TextEditingController option1controller = TextEditingController();
  TextEditingController option2controller = TextEditingController();
  TextEditingController option3controller = TextEditingController();
  TextEditingController option4controller = TextEditingController();
  List<Menu> menu = [];
  List<Drinks> drinks = [];
  List<ChipData> FoodChips = [];
  List<ChipData> DrinkChips = [];
  List<int> foodIDS = [];
  List<int> drinkIDS = [];
  int menuIDx = 0;

  String token = '';

  var tomorrow = DateTime.now().add(new Duration(days: 1));

  void deleteFoodChip(int id) {
    FoodChips.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void deleteDrinkChip(int id) {
    DrinkChips.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void removeFood(id) {
    foodIDS.remove(id);
    deleteFoodChip(id);
  }

  void removeDrink(id) {
    drinkIDS.remove(id);
    deleteDrinkChip(id);
  }

  void addFood(menu, index, selectedIndex) {
    FoodChips.add(ChipData(id: menu[index].id!, name: menu[index].Option!));
    foodIDS.add(menu[index].id!);
    selectedIndex = index;
  }

  void addDrink(menu, index, selectedIndex) {
    DrinkChips.add(ChipData(id: menu[index].id!, name: menu[index].Option!));
    drinkIDS.add(menu[index].id!);
    selectedIndex = index;
  }

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

  Future approveUser(user_id) async {
    changemenuStatus(true);
    await getToken();
    final response = await http.put(
      Uri.parse(AppURL.approveUser),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer" + " " + "$token",
      },
      body: jsonEncode(<String, int>{
        'user_id': user_id,
      }),
    );
    if (response.statusCode == 200) {
      changemenuStatus(false);
    }
  }

  Future<List<Orders>?> getOrders(context) async {
    await getToken();
    List<Orders>? list;
    final response =
        await http.get(Uri.parse(AppURL.allOrders), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: "Bearer" + " " + "$token",
    });
    if (response.statusCode == 200) {
      String data = response.body;
      print(data);
      var rest = jsonDecode(data)['data'] as List;
      list = rest.map<Orders>((json) => Orders.fromJson(json)).toList();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog(context, () {
            Navigator.pop(context);
          }, 'No Orders', 'where', 'Exit');
        },
      );
      print(response.statusCode);
      print(response);
    }
    return list;
  }

  Future orderFood(context) async {
    changeStatus(true);
    await getToken();
    final response = await http.post(
      Uri.parse('https://bsl-foodapp-backend.herokuapp.com/api/order'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer" + " " + "$token",
      },
      body: jsonEncode(<String, dynamic>{
        'menu_id': menuIDx,
        'food_id': foodSelected.toString(),
        'drink_id': drinkSelected.toString(),
        'comment': textFieldController.text,
      }),
    );
    if (response.statusCode == 202) {
      changeStatus(false);
      print(response.body);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog(context, () {
            Navigator.pushNamedAndRemoveUntil(
                context, '/history', (route) => false);
          }, 'Order Placed', 'Your order has been placed', 'View History');
        },
      );
    } else {
      changeStatus(false);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog(context, () {
            Navigator.pushNamed(context, '/history');
          }, 'Uh Oh', 'You\'ve already placed an order', 'History');
        },
      );
    }
  }

  Future<List<Menu>?> fetchFood(context) async {
    await getToken();
    print(tomorrow);
    String formatDate = DateFormat("yyyy-MM-dd").format(tomorrow);
    print(formatDate);
    List<Menu>? list;
    final response = await http.get(
      Uri.parse(AppURL.getMenu + '?menu_date=$formatDate'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer" + " " + "$token",
      },
    );

    if (response.statusCode == 200) {
      String data = response.body;
      menuIDx = jsonDecode(data)['data']['menu_id'];

      var foods = jsonDecode(data)['data']['foods'] as List;
      var allDrinks = jsonDecode(data)['data']['drinks'] as List;
      print(allDrinks);
      menu = foods.map<Menu>((json) => Menu.fromJson(json)).toList();
      drinks = allDrinks.map<Drinks>((json) => Drinks.fromJson(json)).toList();
      Navigator.pushNamed(context, '/third');
    } else if (response.statusCode == 401) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog(context, () {
            Navigator.pushNamed(context, '/history');
          }, 'Please wait', 'There\'s no menu for this date yet',
              'View History');
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

  Future<List<Menu>?> fetchPreviousMenus(context) async {
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
      var rest = jsonDecode(data)['data'] as List;
      list = rest.map<Orders>((json) => Orders.fromJson(json)).toList();
    } else {
      String data = response.body;
      print(data);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog(context, () {
            logout(context);
          }, 'Uh Oh', 'We\'ve run into a serious problem', 'Logout');
        },
      );
    }
    return list;
  }

  Future<List<Foods>?> fetchAllFoods(context) async {
    await getToken();
    List<Foods>? list;
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
      list = rest.map<Foods>((json) => Foods.fromJson(json)).toList();
      notifyListeners();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog(
              context, null, 'Uh Oh', 'We\'ve run into a problem', '');
        },
      );
    }
    return list;
  }

  Future<List<Foods>?> fetchAllDrinks(context) async {
    await getToken();
    List<Foods>? list;
    final response = await http.get(
      Uri.parse(AppURL.Drinks),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer" + " " + "$token",
      },
    );

    if (response.statusCode == 200) {
      String data = response.body;

      var rest = jsonDecode(data)['drinks'] as List;
      list = rest.map<Foods>((json) => Foods.fromJson(json)).toList();
      notifyListeners();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog(
              context, null, 'Uh Oh', 'We\'ve run into a problem', '');
        },
      );
    }
    return list;
  }

  Future addMenu(foodList, drinkList, context) async {
    await getToken();
    changemenuStatus(true);
    final response = await http.post(
      Uri.parse('https://bsl-foodapp-backend.herokuapp.com/api/menu'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer" + " " + "$token",
      },
      body: jsonEncode(<String, dynamic>{
        "menu_date": "$tomorrow",
        "foods_id": foodList,
        "drinks_id": drinkList
      }),
    );

    if (response.statusCode == 201) {
      String data = response.body;
      print(response.body);
      changemenuStatus(false);
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
      changemenuStatus(false);
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
            Navigator.pop(context);
          }, 'Error', message, 'Exit');
        },
      );
      print(response.statusCode);
      print(response);
    }
    return list;
  }
}
