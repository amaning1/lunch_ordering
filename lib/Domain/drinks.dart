class Drinks {
  int? id;
  String? Option;

  Drinks({this.id, this.Option});

  factory Drinks.fromJson(Map<String, dynamic> responseData) {
    return Drinks(
      id: responseData['drink_id'],
      Option: responseData['drink_name'],
    );
  }
}

class DrinksMenu {
  List<Drinks>? drinks;

  DrinksMenu({this.drinks});

  factory DrinksMenu.fromJson(Map<String, dynamic> responseData) {
    var foods = responseData['foods'] as List;
    print(foods.runtimeType);
    List<Drinks> foodList = foods.map((i) => Drinks.fromJson(i)).toList();

    return DrinksMenu(drinks: responseData['drinks']);
  }
}
