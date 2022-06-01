import 'package:flutter/material.dart';
import 'package:lunch_ordering/shared_preferences.dart';
import '../Domain/ChipData.dart';

class Manage extends ChangeNotifier {
  bool _isLoading = false;
  bool _updateOrder = false;
  bool _isLoadingRegister = false;
  bool _menuLoading = false;
  bool _isMenu = false;
  List<ChipData> Chips = [];

  bool _rememberMe = false;

  String _type = '';
  bool get updateOrder => _updateOrder;
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

  bool get isLoading {
    return _isLoading;
  }

  bool get isMenu {
    return _isMenu;
  }

  bool get menuLoading {
    return _menuLoading;
  }

  bool get isLoadingRegister {
    return _isLoadingRegister;
  }

  bool get rememberMe {
    return _rememberMe;
  }

  void changeUpdateOrder(bool updateOrder) {
    _updateOrder = updateOrder;
    notifyListeners();
  }

  void changeMenu(bool isMenu) {
    _isMenu = isMenu;
    notifyListeners();
  }

  void changeMenuStatus(bool isLoading) {
    _menuLoading = isLoading;
    notifyListeners();
  }

  void changeStatus(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void changeRegisterStatus(bool isLoadingRegister) {
    _isLoadingRegister = isLoadingRegister;
    notifyListeners();
  }

  void switchSelected(bool switchSelected) {
    _rememberMe = switchSelected;
    notifyListeners();
  }
}
