class OldOrders {
  int id;
  String? name;
  String food, drink;
  String? comment;
  var time;

  OldOrders(
      {required this.id,
      required this.food,
      required this.drink,
      this.comment,
      this.time,
      this.name});
  factory OldOrders.fromJson(Map<String, dynamic> responseData) {
    return OldOrders(
      id: responseData['id'],
      food: responseData['food_name'],
      drink: responseData['drink_name'],
      comment: responseData['comment'],
      time: responseData['created_at'],
      name: responseData['name'],
    );
  }
}
