import 'package:flutter/material.dart';
import 'package:lunch_ordering/main-screen.dart';
import 'package:lunch_ordering/sign-in.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Lunch Ordering',
      theme: ThemeData(
        primarySwatch: Colors.grey,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SignIn(),
        '/second': (context) => MenuScreen(),
      },
    );
  }
}
