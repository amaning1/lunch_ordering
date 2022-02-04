import 'package:flutter/material.dart';
import 'package:lunch_ordering/main-screen.dart';
import 'package:lunch_ordering/sign-in.dart';
import 'package:firebase_core/firebase_core.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    future:
    Firebase.initializeApp();
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
