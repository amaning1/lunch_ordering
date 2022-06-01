class Menu {
  int? food_id;
  String? food_name;

  Menu({this.food_id, this.food_name});

  factory Menu.fromJson(Map<String, dynamic> responseData) {
    return Menu(
      food_id: responseData['food_id'],
      food_name: responseData['food_name'],
    );
  }
}
