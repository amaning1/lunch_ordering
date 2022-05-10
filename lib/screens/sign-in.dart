import 'dart:async';
import 'package:lunch_ordering/Manage.dart';
import 'package:lunch_ordering/shared_preferences.dart';
import 'dart:convert';
import 'package:lunch_ordering/components.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lunch_ordering/constants.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../APIs.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool isLoggedin = false;
  var size, height, width, token;
  late String phone_number = '';
  late String password = '';
  bool SwitchSelected = false;
  bool isObscure = true;
  bool isLoading = false;
  final TextEditingController numbercontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  late SharedPreferences logindata;
  late bool newuser;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    getToken();
    autoLogIn();
    loadUserNumberPassword(SwitchSelected);
  }

  @override
  void dispose() {
    passwordcontroller.dispose();
    numbercontroller.dispose();
    super.dispose();
  }

  LoginImplementation() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      saveUserDetails(numbercontroller.text, passwordcontroller.text);
      login(numbercontroller.text, passwordcontroller.text);
    }
  }

  Future autoLogIn() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');
    var phone_number_pref = prefs.getString('phone_number');
    var password_pref = prefs.getString('password');

    if (phone_number_pref != null) {
      setState(() {
        phone_number = phone_number_pref;
        password = password_pref!;
      });
      login(phone_number, password);
    }
  }

  Future login(number, password) async {
    final response = await http.post(
      Uri.parse(AppURL.Login),
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

      isLoading = false;
      print(token + name + phone_number);
      print(number);
      print(password);
      print(type + status);
      final SharedPreferences sharedPreferences =
          await SharedPreferences.getInstance();
      sharedPreferences.setString('token', token);

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
      setState(() {
        isLoading = false;
      });
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

  saveUserDetails(numbercontroller, passwordcontroller) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('phone_number', numbercontroller);
    prefs.setString('password', passwordcontroller);
  }

  Future loadUserNumberPassword(boolValue) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var phone_number = prefs.getString('phone_number');
      var password = prefs.getString('password');
      var rememberMe = prefs.getBool("remember_me");
      print(rememberMe);
      print(phone_number);
      print(password);

      if (rememberMe == true) {
        setState(() {
          boolValue = true;
          numbercontroller.text = phone_number!;
          passwordcontroller.text = password!;
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.height;
    bool isloading = Provider.of<Manage>(context).status;
    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: Form(
              key: formKey,
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * 0.050),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('images/img.png', height: 40, width: 45),
                          const SizedBox(width: 5),
                          const Text('BSL ORDERS',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                fontFamily: 'Poppins',
                              )),
                        ],
                      ),
                    ),
                    SizedBox(height: height * 0.035),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 4,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(20.0, 17, 20, 17),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(height: height * 0.02),
                            Center(
                              child: Text('Nice to see you again',
                                  style: KNTSYAStyle),
                            ),
                            SizedBox(height: height * 0.05),
                            Text('Phone Number', style: KButtonTextStyle),
                            SizedBox(height: height * 0.01),
                            form(
                              focusedBorder: true,
                              controller: numbercontroller,
                              label: 'Phone Number',
                              type: TextInputType.number,
                              colour: Color(0xFFF2F2F2),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('Password', style: KButtonTextStyle),
                                TextButton(
                                  onPressed: () {},
                                  child: Text('Forgot Password ?',
                                      style: TextStyle(
                                          color: blue,
                                          fontFamily: 'Poppins',
                                          fontWeight: FontWeight.w400,
                                          fontSize: 15)),
                                ),
                              ],
                            ),
                            passwordForm(
                              passwordcontroller: passwordcontroller,
                            ),
                            SizedBox(height: height * 0.01),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Switch(
                                  value: SwitchSelected,
                                  onChanged: (bool value) {
                                    SwitchSelected = value;
                                    SharedPreferences.getInstance()
                                        .then((prefs) {
                                      prefs.setBool("remember_me", value);
                                    });
                                    setState(() {
                                      SwitchSelected = value;
                                    });
                                  },
                                ),
                                const Text(
                                  'Remember me',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15),
                                ),
                              ],
                            ),
                            Center(
                              child: Container(
                                width: width,
                                height: height * 0.1,
                                child: Button(
                                  text: 'Continue',
                                  isLoading: isLoading,
                                  onPressed: () async {
                                    LoginImplementation();
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 14),
                              child: Divider(
                                thickness: 1.0,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Don\'t have an account?',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/signup');
                                  },
                                  child: Text(
                                    'Sign up now',
                                    style: TextStyle(
                                        color: blue,
                                        fontFamily: 'Poppins',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 15),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: height * 0.07),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
