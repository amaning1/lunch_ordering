import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lunch_ordering/components.dart';
import 'package:lunch_ordering/constants.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final TextEditingController numbercontroller = TextEditingController();
  final TextEditingController passwordcontroller = TextEditingController();
  final TextEditingController namecontroller = TextEditingController();
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var height, width;
  @override
  void dispose() {
    numbercontroller.dispose();
    passwordcontroller.dispose();
    super.dispose();
  }

  registerImplementation() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      register();
    }
  }

  Future<User?> register() async {
    final String token;
    final response = await http.post(
      Uri.parse('https://bsl-foodapp-backend.herokuapp.com/api/register'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'phone_number': numbercontroller.text,
        'password': passwordcontroller.text,
        'type': "1",
        'name': namecontroller.text,
      }),
    );

    if (response.statusCode == 201) {
      String data = response.body;
      Navigator.pushNamed(context, '/signin');
    } else {
      print(response.statusCode);
      print(response.body);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.height;
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
                              child: Text('Nice to see you here',
                                  style: KNTSYAStyle),
                            ),
                            SizedBox(height: height * 0.05),
                            Text('Name', style: KButtonTextStyle),
                            SizedBox(height: height * 0.01),
                            form(
                              focusedBorder: true,
                              controller: namecontroller,
                              label: 'Enter Name',
                              type: TextInputType.text,
                              colour: Color(0xFFF2F2F2),
                            ),
                            Text('Phone Number', style: KButtonTextStyle),
                            SizedBox(height: height * 0.01),
                            form(
                              focusedBorder: true,
                              controller: numbercontroller,
                              label: 'Phone Number',
                              type: TextInputType.number,
                              colour: Color(0xFFF2F2F2),
                            ),
                            Text('Password', style: KButtonTextStyle),
                            SizedBox(height: height * 0.01),
                            passwordForm(
                              passwordcontroller: passwordcontroller,
                            ),
                            SizedBox(height: height * 0.01),
                            Center(
                              child: Container(
                                width: width,
                                height: height * 0.1,
                                child: Button(
                                  text: 'Continue',
                                  isLoading: isLoading,
                                  onPressed: () async {
                                    registerImplementation();
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
                                  'Have an account?',
                                  style: TextStyle(
                                      fontFamily: 'Poppins',
                                      fontWeight: FontWeight.w400,
                                      fontSize: 15),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/signin');
                                  },
                                  child: Text(
                                    'Sign in',
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
