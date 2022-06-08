import 'package:flutter/material.dart';
import 'package:lunch_ordering/shared_preferences.dart';
import '../Domain/ChipData.dart';

class Manage extends ChangeNotifier {
  bool _isLoading = false;
  bool _updateOrder = false;
  bool _isMenu = false;
  bool _isUser = false;
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

  bool get isUser {
    return _isUser;
  }

  bool get isLoading {
    return _isLoading;
  }

  bool get isMenu {
    return _isMenu;
  }

  bool get rememberMe {
    return _rememberMe;
  }

  void changeUser(bool changeUser) {
    _isUser = changeUser;
    notifyListeners();
  }

  void changeUpdateOrder(bool updateOrder) {
    _updateOrder = updateOrder;
    notifyListeners();
  }

  void changeMenu(bool isMenu) {
    _isMenu = isMenu;
    notifyListeners();
  }

  void changeStatus(bool isLoading) {
    _isLoading = isLoading;
    notifyListeners();
  }

  void switchSelected(bool switchSelected) {
    _rememberMe = switchSelected;
    notifyListeners();
  }
}
