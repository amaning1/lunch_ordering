import 'package:flutter/cupertino.dart';

import '../Domain/user.dart';

class UserProvider extends ChangeNotifier {
  User _user = User();

  User get user => _user;

  set user(User? value) {
    _user = user;
    notifyListeners();
  }
}
