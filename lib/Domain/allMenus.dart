// To parse this JSON data, do
//
//     final allMenus = allMenusFromJson(jsonString);

import 'dart:convert';

AllMenu allMenusFromJson(String str) => AllMenu.fromJson(json.decode(str));

String allMenusToJson(AllMenu data) => json.encode(data.toJson());

class AllMenu {
  AllMenu({
    required this.data,
  });

  List<Datum> data;

  factory AllMenu.fromJson(Map<String, dynamic> json) => AllMenu(
        data: List<Datum>.from(json["data"].map((x) => Datum.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "data": List<dynamic>.from(data.map((x) => x.toJson())),
      };
}

class Datum {
  Datum({
    required this.menuId,
    required this.foods,
    required this.drinks,
  });

  int menuId;
  List<Food> foods;
  List<Drink> drinks;

  factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        menuId: json["menu_id"],
        foods: List<Food>.from(json["foods"].map((x) => Food.fromJson(x))),
        drinks: List<Drink>.from(json["drinks"].map((x) => Drink.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "menu_id": menuId,
        "foods": List<dynamic>.from(foods.map((x) => x.toJson())),
        "drinks": List<dynamic>.from(drinks.map((x) => x.toJson())),
      };
}

class Drink {
  Drink({
    required this.drinkId,
    required this.drinkName,
  });

  int drinkId;
  String drinkName;

  factory Drink.fromJson(Map<String, dynamic> json) => Drink(
        drinkId: json["drink_id"],
        drinkName: json["drink_name"],
      );

  Map<String, dynamic> toJson() => {
        "drink_id": drinkId,
        "drink_name": drinkName,
      };
}

class Food {
  Food({
    required this.foodId,
    required this.foodName,
  });

  int foodId;
  String foodName;

  factory Food.fromJson(Map<String, dynamic> json) => Food(
        foodId: json["food_id"],
        foodName: json["food_name"],
      );

  Map<String, dynamic> toJson() => {
        "food_id": foodId,
        "food_name": foodName,
      };
}
