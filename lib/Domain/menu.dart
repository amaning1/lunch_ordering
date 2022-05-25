class Menu {
  int? id;
  String? Option;

  Menu({this.id, this.Option});

  factory Menu.fromJson(Map<String, dynamic> responseData) {
    return Menu(
      id: responseData['food_id'],
      Option: responseData['food_name'],
    );
  }
}
