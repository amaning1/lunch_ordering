import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:lunch_ordering/constants.dart';
import 'package:lunch_ordering/controllers/providers/approval_provider.dart';
import 'package:lunch_ordering/controllers/providers/food_providers.dart';
import 'package:lunch_ordering/controllers/providers/menu_provider.dart';
import 'package:lunch_ordering/controllers/providers/registration_provider.dart';
import 'package:lunch_ordering/controllers/providers/auth_provider.dart';
import 'package:lunch_ordering/views/screens/menu-loading-screen.dart';
import 'package:lunch_ordering/views/screens/menu/add-menu.dart';
import 'package:lunch_ordering/views/screens/menu/admin-add-user.dart';
import 'package:lunch_ordering/views/screens/menu/admin-add-to-menu.dart';
import 'package:lunch_ordering/views/screens/menu/admin-approval-requests.dart';
import 'package:lunch_ordering/views/screens/menu/admin-view-drinks.dart';
import 'package:lunch_ordering/views/screens/menu/admin-view-foods.dart';
import 'package:lunch_ordering/views/screens/main-screen.dart';
import 'package:lunch_ordering/views/screens/menu/admin-view-orders.dart';
import 'package:lunch_ordering/views/screens/menu/all-menus.dart';
import 'package:lunch_ordering/views/screens/menu/all-users.dart';
import 'package:lunch_ordering/views/screens/sign-in.dart';
import 'package:lunch_ordering/views/screens/sign-up.dart';
import 'package:lunch_ordering/views/screens/splash-screen.dart';
import 'package:lunch_ordering/views/screens/loading-screen.dart';
import 'package:lunch_ordering/views/screens/user-main.dart';
import 'package:lunch_ordering/views/screens/view-history.dart';
import 'package:provider/provider.dart';
import 'package:lunch_ordering/controllers/providers/Manage.dart';
import 'package:cron/cron.dart';


void main() {
  WidgetsFlutterBinding.ensureInitialized();
  AwesomeNotifications().initialize('', [NotificationChannel(channelKey: 'key1',
  channelName: 'Lunch Ordering',
      channelDescription: 'Notification to order lunch', playSound: true,enableVibration: true)]);
  final cron = Cron();
  cron.schedule(Schedule.parse('0 15 * * *'), () async => {
       await AwesomeNotifications().createNotification(content: NotificationContent(id: 1, channelKey: 'key1', title: 'Order for tomorrow', body: 'Tomorrow\'s menu is ready. Please order now '))

});
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

  void Notify() async {
String timeZone = await AwesomeNotifications().getLocalTimeZoneIdentifier();
    await AwesomeNotifications().createNotification(content: NotificationContent(icon: '@mipmap/ic_launcher',id: 1, channelKey: 'key1', title: 'Order for tomorrow', body: 'Tomorrow\'s menu is ready. Please order now '),schedule: NotificationInterval(interval: 1,timeZone: timeZone,));
  }

}
