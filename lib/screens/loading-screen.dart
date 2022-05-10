import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:lunch_ordering/screens/sign-in.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  @override
  void initState() {
    super.initState();
    autoLogIn();
  }

  Future login(number, password) async {
    final response = await http.post(
      Uri.parse('https://bsl-foodapp-backend.herokuapp.com/api/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phone_number': number,
        'password': password,
      }),
    );

    if (response.statusCode == 202) {
      String data = response.body;

      final String token = jsonDecode(data)['data']['token'];
      final String name = jsonDecode(data)['data']['user']['name'];
      final String phone_number =
          jsonDecode(data)['data']['user']['phone_number'];
      final int type = jsonDecode(data)['data']['user']['type'];
      final int status = jsonDecode(data)['data']['user']['status'];

      print(token + name + phone_number);
      print(number);
      print(password);
      print(type + status);

      if (type == 2 || type == 1) {
        final SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString('token', token);
        Navigator.pushNamed(context, '/fourth');
      } else {
        final SharedPreferences sharedPreferences =
            await SharedPreferences.getInstance();
        sharedPreferences.setString('token', token);
        Navigator.pushNamed(context, '/third');
      }
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return alertDialog(response);
        },
      );
      print(response.statusCode);
      print(response.body);
    }
    return null;
  }

  Future autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    newuser = prefs.getBool('remember_me') ?? false;
    print(newuser);
    var phone_number_pref = prefs.getString('phone_number');
    var password_pref = prefs.getString('password');

    if (phone_number_pref != null) {
      CircularProgressIndicator();
      setState(() {
        phone_number = phone_number_pref;
        password = password_pref!;
      });
      login(phone_number, password);
    } else {
      CircularProgressIndicator();
      Navigator.pushNamedAndRemoveUntil(context, '/signin', (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(8.0),
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
