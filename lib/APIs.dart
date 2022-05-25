class AppURL {
  static const String baseURL = 'https://bsl-foodapp-backend.herokuapp.com/api';
  static const String Login = baseURL + '/login';
  static const String Register = baseURL + '/register';
  static const String getMenu = baseURL + '/menu?menu_date=2022-05-24';
  static const String orderMenu = baseURL + '/order';
  static const String Foods = baseURL + '/food';
  static const String Drinks = baseURL + '/drink';
  static const String forgotPassword = baseURL + '/forgot-password';
  static const String allOrders = baseURL + '/order/daily?menu_date=2022-05-25';
}
