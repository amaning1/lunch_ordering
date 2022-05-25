import 'package:flutter/material.dart';
import 'package:lunch_ordering/shared_preferences.dart';

import '../Domain/ChipData.dart';

class Manage extends ChangeNotifier {
  bool _isloading = false;
  bool _isloadingregister = false;
  bool _isloadingmenu = false;
  bool _menuloading = false;
  List<ChipData> Chips = [];

  bool get isloadingmenu => _isloadingmenu;
  bool _rememberMe = false;
  late int _menuIDx;

  String _type = '';

  String get type {
    return _type;
  }

  String typeFood() {
    _type = 'Food';
    notifyListeners();
    return type;
  }

  String typeDrink() {
    _type = 'Drink';
    notifyListeners();
    return type;
  }

  // void deleteChip(Chips){
  //     Chips.removeWhere((element) => element.id == id);
  // }

  int get menuIDx => _menuIDx;

  set menuIDx(int value) {
    _menuIDx = value;
  }

  bool get isloading {
    return _isloading;
  }

  bool get menuloading {
    return _menuloading;
  }

  bool get isloadingregister {
    return _isloadingregister;
  }

  bool get rememberMe {
    return _rememberMe;
  }

  void changemenuStatus(bool isLoading) {
    _menuloading = isLoading;
    notifyListeners();
  }

  void changeStatus(bool isLoading) {
    _isloading = isLoading;
    notifyListeners();
  }

  void changeRegisterStatus(bool isLoadingregister) {
    _isloadingregister = isLoadingregister;
    notifyListeners();
  }

  void switchSelected(bool switchSelected) {
    _rememberMe = switchSelected;
    notifyListeners();
  }
}
