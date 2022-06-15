import 'package:flutter/material.dart';
import 'package:lunch_ordering/constants.dart';
import 'package:lunch_ordering/providers/approval_provider.dart';
import 'package:lunch_ordering/providers/food_providers.dart';
import 'package:lunch_ordering/providers/menu_provider.dart';
import 'package:lunch_ordering/providers/registration_provider.dart';
import 'package:lunch_ordering/providers/auth_provider.dart';
import 'package:lunch_ordering/screens/menu-loading-screen.dart';
import 'package:lunch_ordering/screens/menu/add-menu.dart';
import 'package:lunch_ordering/screens/menu/admin-add-user.dart';
import 'package:lunch_ordering/screens/menu/admin-add-to-menu.dart';
import 'package:lunch_ordering/screens/menu/admin-approval-requests.dart';
import 'package:lunch_ordering/screens/menu/admin-view-drinks.dart';
import 'package:lunch_ordering/screens/menu/admin-view-foods.dart';
import 'package:lunch_ordering/screens/main-screen.dart';
import 'package:lunch_ordering/screens/menu/admin-view-orders.dart';
import 'package:lunch_ordering/screens/menu/all-menus.dart';
import 'package:lunch_ordering/screens/menu/all-users.dart';
import 'package:lunch_ordering/screens/sign-in.dart';
import 'package:lunch_ordering/screens/sign-up.dart';
import 'package:lunch_ordering/screens/splash-screen.dart';
import 'package:lunch_ordering/screens/loading-screen.dart';
import 'package:lunch_ordering/screens/user-main.dart';
import 'package:lunch_ordering/screens/view-history.dart';
import 'package:provider/provider.dart';
import 'package:lunch_ordering/providers/Manage.dart';

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
        ChangeNotifierProvider(create: (_) => RegProvider()),
        ChangeNotifierProvider(create: (_) => ApprovalProvider()),
        ChangeNotifierProvider(create: (_) => MenuProvider())
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Lunch Ordering',
        theme: ThemeData(
          primaryColor: darkBlue,
        ),
        initialRoute: '/loadingscreen',
        routes: {
          '/loadingscreen': (context) => const LoadingScreen(),
          '/signin': (context) => const SignIn(),
          '/signup': (context) => const SignUp(),
          '/third': (context) => const MenuScreen(),
          '/adminAdd': (context) => const AdminAdd(),
          '/adminOrders': (context) => const AdminOrders(),
          '/history': (context) => const ViewHistory(),
          '/splash': (context) => const SplashScreen(),
          '/allMenus': (context) => const AllMenus(),
          '/addMenu': (context) => const AddMenu(),
          '/adminViewOrders': (context) => const AdminViewOrders(),
          '/adminAddUser': (context) => const AdminAddUser(),
          '/adminApprovalRequests': (context) => const AdminApprovalRequests(),
          '/User': (context) => const UserMain(),
          '/menuLoading': (context) => const MenuLoadingScreen(),
          '/allUsers': (context) => const EveryUser(),
          '/allDrinks': (context) => const ViewDrinks(),
        },
      ),
    );
  }
}
