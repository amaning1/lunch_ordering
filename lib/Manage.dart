import 'package:flutter/material.dart';

class Manage extends ChangeNotifier {
  bool isloading = false;

  bool get status {
    return isloading;
  }

  void changeStatus() {
    isloading = !isloading;
    notifyListeners();
  }
}
