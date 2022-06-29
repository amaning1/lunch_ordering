class AllUsers {
  String created_at;
  String status;
  String name;
  String phone_number;
  String type;
  int id;

  AllUsers(
      {required this.created_at,
      required this.status,
      required this.name,
      required this.phone_number,
      required this.type,
      required this.id});

  factory AllUsers.fromJson(Map<String, dynamic> responseData) {
    return AllUsers(
        id: responseData['id'],
        created_at: responseData['created_at'],
        status: responseData['status'],
        name: responseData['name'],
        phone_number: responseData['phone_number'],
        type: responseData['type']);
  }
}
