class User {
  String? token;
  int? status;
  String? name;
  String? phone_number;
  int? type;

  User({this.token, this.status, this.name, this.phone_number, this.type});

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
        token: responseData['data']['token'],
        status: responseData['data']['user']['name'],
        name: responseData['data']['user']['name'],
        phone_number: responseData['data']['user']['phone_number'],
        type: responseData['data']['user']['type']);
  }
}
