import 'dart:io';
import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:intl/intl.dart';
import 'package:lunch_ordering/components.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lunch_ordering/screens/menu/all-menus.dart';
import '../APIs.dart';
import '../Domain/ChipData.dart';
import '../Domain/drinks.dart';
import '../Domain/foods.dart';
import '../Domain/menu.dart';
import '../Domain/allMenus.dart';
import '../Domain/new-user.dart';
import '../Domain/oldOrders.dart';
import '../Domain/orders.dart';
import '../constants.dart';
import '../screens/main-screen.dart';
import '../screens/user-main.dart';
import '../screens/view-history.dart';
import '../shared_preferences.dart';
import 'Manage.dart';

class FoodProvider extends Manage {
  final TextEditingController comments = TextEditingController();
  List<Menu> menu = [];
  List<OldOrders> list = [];
  List<Orders> listOrders = [];
  List<Drink> drinks = [];
  List<Drinks> allDrinks = [];
  List<Foods> allFoods = [];
  List<ChipData> foodChips = [];
  List<ChipData> drinkChips = [];
  List<int> foodIDS = [];
  List<int> drinkIDS = [];
  int menuIDx = 0;
  List allOrders = [];
  late OldOrders oldOrders;
  int? selectedFoodIndex;
  int? selectedDrinkIndex;

  var time = DateTime.now().add(const Duration(days: 1));
  var newHour = 7;
  var chefHour = 14;

  void date() {
    var currentTime = DateTime.now();
    DateTime userTime =
        DateTime(currentTime.year, currentTime.month, currentTime.day, newHour);
    print(isUser);
    DateTime chefTime = DateTime(
        currentTime.year, currentTime.month, currentTime.day, chefHour);

    if (isUser) {
      if (currentTime.isBefore(userTime)) {
        time = DateTime.now();
      } else {
        time = time;
      }
    } else {
      if (currentTime.isBefore(chefTime)) {
        time = DateTime.now();
      } else {
        time = time;
      }
    }
  }

  void deleteFoodChip(int id) {
    foodChips.removeWhere((element) => element.id == id);
    notifyListeners();
  }

  void deleteDrinkChip(int id) {
    drinkChips.removeWhere((element) => element.id == id);
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
    foodChips.add(ChipData(id: menu[index].id!, name: menu[index].Option!));
    foodIDS.add(menu[index].id!);
    selectedIndex = index;
  }

  void addDrink(menu, index, selectedIndex) {
    drinkChips.add(ChipData(id: menu[index].id!, name: menu[index].Option!));
    drinkIDS.add(menu[index].id!);
    selectedIndex = index;
  }

  Future deleteFood(foodId) async {
    await getToken();
    final response = await http.delete(
      Uri.parse(AppURL.Foods),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer" + " " + token!,
      },
      body: jsonEncode(<String, int>{
        'food_id': foodId,
      }),
    );
  }

  Future addNewFood(food, context) async {
    await getToken();
    final response = await http.post(
      Uri.parse(AppURL.Drinks),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer" " " "$token",
      },
      body: jsonEncode(<String, dynamic>{
        'foods': "[$food]",
      }),
    );
    if (response.statusCode == 201) {
      changeStatus(false);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog(context, () {
            Navigator.pop(context);
          }, 'Food Added', 'Your food has been added', 'Exit');
        },
      );
    } else {
      print(response.body);
    }
  }

  Future addNewDrink(drink, context) async {
    await getToken();
    final response = await http.post(
      Uri.parse(AppURL.Drinks),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer" " " "$token",
      },
      body: jsonEncode(<String, dynamic>{
        'drinks': "[$drink]",
      }),
    );
    if (response.statusCode == 201) {
      changeStatus(false);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog(context, () {
            Navigator.pop(context);
          }, 'Drink Added', 'Your drink has been added', 'Exit');
        },
      );
    } else {
      print(response.body);
    }
  }

  Future updateFoodOrder(context) async {
    changeStatus(true);
    // await getToken();
    final response = await http.put(
      Uri.parse('https://bsl-foodapp-backend.herokuapp.com/api/order'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer" " " "$token",
      },
      body: jsonEncode(<String, dynamic>{
        'order_id': oldOrders.id,
        'user_id': oldOrders.id,
        'menu_id': menuIDx,
        'food_id': foodSelected.toString(),
        'drink_id': drinkSelected.toString(),
        'comment': comments.text.isEmpty ? ' ' : comments.text,
      }),
    );
    getPreviousOrders(context);
    if (response.statusCode == 200) {
      changeStatus(false);
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
      print(response.body);

      var formatDate = DateTime.tryParse(oldOrders.time!);
      String Date = DateFormat("yyyy-MM-dd").format(formatDate!);
      changeStatus(false);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomWidget(
            food: oldOrders.food,
            drink: oldOrders.drink,
            date: Date,
          );
        },
      );
    }
  }

  Future<List<Orders>?> getOrders(context) async {
    await getToken();
    date();
    String formatDate = DateFormat("yyyy-MM-dd").format(time);
    print(formatDate);
    List<Orders>? list;
    final response = await http.get(
        Uri.parse(AppURL.allOrders + '?menu_date=$formatDate'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          HttpHeaders.authorizationHeader: "Bearer" + " " + "$token",
        });
    if (response.statusCode == 200) {
      String data = response.body;
      print(data);
      var rest = jsonDecode(data)['data'] as List;
      listOrders = rest.map<Orders>((json) => Orders.fromJson(json)).toList();
    } else {
      listOrders = [];
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
        HttpHeaders.authorizationHeader: "Bearer" " " "$token",
      },
      body: jsonEncode(<String, dynamic>{
        'menu_id': menuIDx,
        'food_id': foodSelected.toString(),
        'drink_id': drinkSelected.toString(),
        'comment': comments.text,
      }),
    );
    getPreviousOrders(context);
    if (response.statusCode == 202) {
      changeStatus(false);
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
      var formatDate = DateTime.tryParse(oldOrders.time!);
      String Date = DateFormat("yyyy-MM-dd").format(formatDate!);

      changeStatus(false);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return CustomWidget(
            food: oldOrders.food,
            drink: oldOrders.drink,
            date: Date,
          );
        },
      );
    }
  }

  Future<List<Menu>?> fetchFood(context) async {
    await getToken();
    changeUser(true);
    notifyListeners();
    date();
    String formatDate = DateFormat("yyyy-MM-dd").format(time);
    print(formatDate);
    getPreviousOrders(context);

    final response = await http.get(
      Uri.parse(AppURL.getMenu + '?menu_date=$formatDate'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer" " " + token!,
      },
    );

    if (response.statusCode == 200) {
      String data = response.body;
      menuIDx = jsonDecode(data)['data']['menu_id'];
      changeMenu(true);
      var foods = jsonDecode(data)['data']['foods'] as List;
      var allDrinks = jsonDecode(data)['data']['drinks'] as List;
      print(allDrinks);
      menu = foods.map<Menu>((json) => Menu.fromJson(json)).toList();
      drinks = allDrinks.map<Drink>((json) => Drink.fromJson(json)).toList();
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const UserMain()));
    } else if (response.statusCode == 401) {
      changeMenu(false);
      Navigator.pushNamed(context, '/User');
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
    return null;
  }

  Future<List<OldOrders>?> getPreviousOrders(context) async {
    // await getToken();
    final response = await http.get(
      Uri.parse(AppURL.orderMenu),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer" + " " + "$token",
      },
    );

    if (response.statusCode == 200) {
      String data = response.body;
      var rest = jsonDecode(data)['data'] as List;
      oldOrders = OldOrders.fromJson(rest.last);
      print(oldOrders);

      list = rest.map<OldOrders>((json) => OldOrders.fromJson(json)).toList();
      print(list);
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
    final response = await http.get(
      Uri.parse(AppURL.Foods),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer" + " " + "$token",
      },
    );

    if (response.statusCode == 200) {
      String data = response.body;
      print(data);
      var rest = jsonDecode(data)['foods'] as List;
      allFoods = rest.map<Foods>((json) => Foods.fromJson(json)).toList();
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
    return allFoods;
  }

  Future<List<Drinks>?> fetchAllDrinks(context) async {
    await getToken();
    final response = await http.get(
      Uri.parse(AppURL.Drinks),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer" + " " + "$token",
      },
    );

    if (response.statusCode == 200) {
      String data = response.body;
      print('why?');
      print(data);
      var rest = jsonDecode(data)['drinks'] as List;
      print('done0');
      allDrinks = rest.map<Drinks>((json) => Drinks.fromJson(json)).toList();
      print('done1');
      notifyListeners();
      print('done2');
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog(
              context, null, 'Uh Oh', 'We\'ve run into a problem', '');
        },
      );
    }
    return allDrinks;
  }
}
