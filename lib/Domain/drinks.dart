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
