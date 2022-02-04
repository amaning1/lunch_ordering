import 'package:flutter/material.dart';
import 'package:lunch_ordering/main-screen.dart';
import 'package:lunch_ordering/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool state = false;
  final _auth = FirebaseAuth.instance;
  late String email;
  late String password;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ModalProgressHUD(
      inAsyncCall: state,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10.0),
            child: TextField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                onChanged: (value) {
                  email = value;
                },
                //obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Email')),
          ),
          Container(
            padding: EdgeInsets.all(10.0),
            child: TextField(
                textAlign: TextAlign.center,
                onChanged: (value) {
                  password = value;
                },
                obscureText: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Password')),
          ),
          Padding(
            padding: const EdgeInsets.all(25.0),
            child: ElevatedButton(
                onPressed: () async {
                  // print(email);
                  // print(password);
                  setState(() {
                    state = true;
                  });
                  try {
                    final User = await _auth.signInWithEmailAndPassword(
                        email: email, password: password);
                    if (User != null) {
                      Navigator.pushNamed(context, '/second');
                    }
                    setState(() {
                      state = false;
                    });
                  } catch (e) {
                    print(e);
                  }
                },
                child: Text('Order')),
          )
        ],
      ),
    ));
  }
}
