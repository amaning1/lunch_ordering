import 'package:flutter/material.dart';
import 'package:lunch_ordering/screens/admin-add.dart';
import 'package:lunch_ordering/screens/admin-orders.dart';
import 'package:lunch_ordering/screens/admin-page.dart';
import 'package:lunch_ordering/screens/admin.dart';
import 'package:lunch_ordering/screens/main-screen.dart';
import 'package:lunch_ordering/screens/sign-in.dart';
import 'package:lunch_ordering/screens/sign-up.dart';
import 'package:lunch_ordering/constants.dart';
import 'package:lunch_ordering/screens/loading-screen.dart';
import 'package:provider/provider.dart';
import 'package:lunch_ordering/Manage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider.value(value: Manage())],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lunch Ordering',
        theme: ThemeData(
          primaryColor: blue,
          colorScheme: ColorScheme.fromSwatch().copyWith(secondary: blue),
        ),
        initialRoute: '/loadingscreen',
        routes: {
          '/loadingscreen': (context) => LoadingScreen(),
          '/signin': (context) => SignIn(),
          '/signup': (context) => SignUp(),
          '/third': (context) => MenuScreen(),
          '/fourth': (context) => AdminPage(),
          '/admin': (context) => Admin(),
          '/adminAdd': (context) => AdminAdd(),
          '/adminOrders': (context) => AdminOrders(),
        },
      ),
    );
  }
}
