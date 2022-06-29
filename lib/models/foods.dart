class Foods {
  int? id;
  String? Option;

  Foods({this.id, this.Option});

  factory Foods.fromJson(Map<String, dynamic> responseData) {
    return Foods(
      id: responseData['id'],
      Option: responseData['name'],
    );
  }
}
