class NewUser {
  String status;
  String name;
  String phone_number;
  String type;
  String? date;
  int? user_id;

  NewUser(
      {required this.status,
      required this.name,
      required this.phone_number,
      required this.type,
      this.date,
      this.user_id});

  factory NewUser.fromJson(Map<String, dynamic> responseData) {
    return NewUser(
      status: responseData['status'],
      name: responseData['name'],
      phone_number: responseData['phone_number'],
      type: responseData['type'],
      user_id: responseData['user_id'],
      date: responseData['created_at'],
    );
  }
}
