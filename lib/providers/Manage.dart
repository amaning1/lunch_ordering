import 'package:flutter/material.dart';
import 'package:lunch_ordering/shared_preferences.dart';

class Manage extends ChangeNotifier {
  bool _isloading = false;
  bool _rememberMe = false;
  late int _menuIDx;

  int get menuIDx => _menuIDx;

  set menuIDx(int value) {
    _menuIDx = value;
  }

  bool get isloading {
    return _isloading;
  }

  bool get rememberMe {
    return _rememberMe;
  }

  void changeStatus(bool isLoading) {
    _isloading = isLoading;
    notifyListeners();
  }

  void switchSelected(bool switchSelected) {
    _rememberMe = switchSelected;
    notifyListeners();
  }
}
