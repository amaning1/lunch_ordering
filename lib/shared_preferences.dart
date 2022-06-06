import 'package:shared_preferences/shared_preferences.dart';

String? token;
saveUserDetails(numberController, passwordController) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('phone_number', numberController);
  prefs.setString('password', passwordController);
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
  token = sharedPreferences.getString('token');

  return token;
}

Future saveToken(token) async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  sharedPreferences.setString('token', token);
}
