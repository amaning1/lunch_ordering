import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lunch_ordering/providers/auth_provider.dart';
import 'package:lunch_ordering/screens/sign-in.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../components.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late bool newuser;
  late String phone_number = '';
  late String password = '';
  late AuthProvider authVm;

  @override
  void initState() {
    super.initState();
    print('sup');
    Future.delayed(Duration.zero, () {
      authVm = Provider.of<AuthProvider>(context, listen: false)
          .autoLogIn(context) as AuthProvider;
    });
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(height * 0.08),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/img.png', height: 50, width: 50),
              const SizedBox(width: 5),
              const Text('BSL ORDERS',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    fontFamily: 'NeueMachina',
                  )),
            ],
          ),
        ),
      ],
    ));
  }
}
