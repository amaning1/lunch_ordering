import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lunch_ordering/providers/auth_provider.dart';
import 'package:lunch_ordering/providers/food_providers.dart';
import 'package:lunch_ordering/screens/sign-in.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components.dart';
import '../constants.dart';
import 'dart:io';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({Key? key}) : super(key: key);

  @override
  State<LoadingScreen> createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  late AuthProvider authVm;

  @override
  void initState() {
    super.initState();
  }

  @override
  Future<void> didChangeDependencies() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Provider.of<AuthProvider>(context, listen: false).autoLogIn(context);
      }
    } on SocketException catch (_) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return alertDialog(context, () {
              SystemNavigator.pop();
            },
                'No internet connection',
                'This application requires an internet connection to proceed',
                'Exit');
          });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(height * 0.08),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/img.png',
                  height: width * 0.2, width: width * 0.2),
              const SizedBox(width: 5),
              const Text('BSL ORDERS', style: KCardTextStyle),
            ],
          ),
        ),
      ],
    ));
  }
}
