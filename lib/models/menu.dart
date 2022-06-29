import 'drinks.dart';

class Menu {
  int? food_id;
  String? food_name;
  List<Menu>? foods;
  List<Drinks>? drinks;

  Menu({this.food_id, this.food_name});

  factory Menu.fromJson(Map<String, dynamic> responseData) {
    return Menu(
      food_id: responseData['food_id'],
      food_name: responseData['food_name'],
    );
  }
}

class FoodMenu {
  List<Menu>? foods;

  FoodMenu({this.foods});

  factory FoodMenu.fromJson(Map<String, dynamic> responseData) {
    var foods = responseData['foods'] as List;
    print(foods.runtimeType);
    List<Menu> foodList = foods.map((i) => Menu.fromJson(i)).toList();

    return FoodMenu(foods: responseData['foods']);
  }
}
