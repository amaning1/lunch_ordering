import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'Domain/user.dart';

class UserPreferences {
  Future<bool> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', user.name);
    prefs.setString('phone_number', user.phone_number);
    prefs.setString('status', user.status);
    prefs.setString('token', user.token);
    prefs.setString('type', user.type);

    return saveUser(user);
  }

  Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('name');
    String? phone_number = prefs.getString('phone_number');
    String? status = prefs.getString('status');
    String? token = prefs.getString('token');
    String? type = prefs.getString('type');

    return User(
      name: name!,
      phone_number: phone_number!,
      status: status!,
      token: token!,
      type: type!,
    );
  }

  void removeUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('name');
    prefs.remove('phone_number');
    prefs.remove('status');
    prefs.remove('token');
    prefs.remove('type');
  }
}

saveUserDetails(numbercontroller, passwordcontroller) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('phone_number', numbercontroller);
  prefs.setString('password', passwordcontroller);
}

Future<bool?> getRememberMe() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  bool? rMBR = sharedPreferences.getBool('remember_me');

  return rMBR;
}

Future getToken() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  var tok = sharedPreferences.getString('token');

  return tok;
}

Future saveToken(token) async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  sharedPreferences.setString('token', token);
}
