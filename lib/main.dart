import 'package:flutter/material.dart';
import 'package:lunch_ordering/providers/food_providers.dart';
import 'package:lunch_ordering/providers/registration_provider.dart';
import 'package:lunch_ordering/providers/auth_provider.dart';
import 'package:lunch_ordering/screens/menu/add-menu.dart';
import 'package:lunch_ordering/screens/menu/admin-add-user.dart';
import 'package:lunch_ordering/screens/menu/admin-add.dart';
import 'package:lunch_ordering/screens/menu/admin-approval-requests.dart';
import 'package:lunch_ordering/screens/menu/admin-orders.dart';
import 'package:lunch_ordering/screens/menu/admin-page.dart';
import 'package:lunch_ordering/screens/main-screen.dart';
import 'package:lunch_ordering/screens/menu/admin-view-orders.dart';
import 'package:lunch_ordering/screens/menu/all-menus.dart';
import 'package:lunch_ordering/screens/sign-in.dart';
import 'package:lunch_ordering/screens/sign-up.dart';
import 'package:lunch_ordering/screens/loading-screen.dart';
import 'package:lunch_ordering/screens/splash-screen.dart';
import 'package:lunch_ordering/screens/view-history.dart';
import 'package:provider/provider.dart';
import 'package:lunch_ordering/providers/Manage.dart';
import 'package:lunch_ordering/constants.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: Manage()),
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => FoodProvider()),
        ChangeNotifierProvider(create: (_) => RegProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lunch Ordering',
        initialRoute: '/loadingscreen',
        routes: {
          '/loadingscreen': (context) => LoadingScreen(),
          '/signin': (context) => SignIn(),
          '/signup': (context) => SignUp(),
          '/third': (context) => MenuScreen(),
          '/fourth': (context) => AdminPage(),
          '/adminAdd': (context) => AdminAdd(),
          '/adminOrders': (context) => AdminOrders(),
          '/history': (context) => ViewHistory(),
          '/splash': (context) => SplashScreen(),
          '/allMenus': (context) => AllMenus(),
          '/addMenu': (context) => AddMenu(),
          '/adminViewOrders': (context) => AdminViewOrders(),
          '/adminAddUser': (context) => AdminAddUser(),
          '/adminApprovalRequests': (context) => AdminApprovalRequests(),
        },
      ),
    );
  }
}
