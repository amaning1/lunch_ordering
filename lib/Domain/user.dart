class User {
  String token;
  String status;
  String name;
  String phone_number;
  String type;

  User({
    required this.token,
    required this.status,
    required this.name,
    required this.phone_number,
    required this.type,
  });

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
        token: responseData['token'],
        status: responseData['user']['name'],
        name: responseData['user']['name'],
        phone_number: responseData['user']['phone_number'],
        type: responseData['user']['type']);
  }
}
