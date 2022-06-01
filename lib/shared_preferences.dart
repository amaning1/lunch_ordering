import 'package:shared_preferences/shared_preferences.dart';

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
  var tok = sharedPreferences.getString('token');

  return tok;
}

Future saveToken(token) async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  sharedPreferences.setString('token', token);
}
