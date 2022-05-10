import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import 'Domain/user.dart';

class UserPreferences {
  Future<bool> saveUser(User user) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('name', user.name!);
    prefs.setString('phone_number', user.phone_number!);
    prefs.setInt('status', user.status!);
    prefs.setString('token', user.token!);
    prefs.setInt('type', user.type!);

    return saveUser(user);
  }

  saveUserDetails(numbercontroller, passwordcontroller) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('phone_number', numbercontroller);
    prefs.setString('password', passwordcontroller);
  }

  Future<User> getUser() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? name = prefs.getString('name');
    String? phone_number = prefs.getString('phone_number');
    int? status = prefs.getInt('status');
    String? token = prefs.getString('token');
    int? type = prefs.getInt('type');

    return User(
      name: name,
      phone_number: phone_number,
      status: status,
      token: token,
      type: type,
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

Future getToken() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  var tok = sharedPreferences.getString('token');

  return tok;
}
