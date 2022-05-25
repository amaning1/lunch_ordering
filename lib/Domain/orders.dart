class Orders {
  int id;
  String food, drink;
  String? comment;
  String? name;

  Orders(
      {required this.id,
      required this.food,
      required this.drink,
      this.comment,
      this.name});
  factory Orders.fromJson(Map<String, dynamic> responseData) {
    return Orders(
      id: responseData['id'],
      food: responseData['food_name'],
      drink: responseData['drink_name'],
      comment: responseData['comment'],
      name: responseData['name'],
    );
  }
}
