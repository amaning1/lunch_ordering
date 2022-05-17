import 'dart:async';
import 'package:lunch_ordering/providers/auth_provider.dart';
import 'package:lunch_ordering/screens/sign-up.dart';
import 'package:lunch_ordering/shared_preferences.dart';
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
  late AuthProvider authVm;

  @override
  void initState() {
    super.initState();
    getToken();
    Future.delayed(Duration.zero, () {
      authVm = Provider.of<AuthProvider>(context, listen: true)
          .autoLogIn(context) as AuthProvider;
      authVm = Provider.of<AuthProvider>(context, listen: true)
          .loadUserNumberPassword() as AuthProvider;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05),
            child: Form(
              key: authProvider.formKey2,
              child: Padding(
                padding: EdgeInsets.all(width * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * 0.050),
                    Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('images/img.png',
                              height: width * 0.1, width: width * 0.125),
                          SizedBox(width: width * 0.01),
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
                        padding: EdgeInsets.fromLTRB(width * 0.05,
                            width * 0.035, width * 0.05, width * 0.035),
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
                              controller: authProvider.numberController,
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
                              passwordcontroller:
                                  authProvider.passwordController,
                            ),
                            SizedBox(height: height * 0.01),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Switch(
                                  value: authProvider.rememberMe,
                                  onChanged: (bool value) {
                                    authProvider.switchSelected(value);
                                    SharedPreferences.getInstance()
                                        .then((prefs) {
                                      prefs.setBool("remember_me",
                                          authProvider.rememberMe);
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
                                  isLoading: authProvider.isloading,
                                  onPressed: () async {
                                    authProvider.LoginImplementation(context);
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: width * 0.025),
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
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const SignUp()),
                                    );
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
