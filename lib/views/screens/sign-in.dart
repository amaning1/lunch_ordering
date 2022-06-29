import 'package:lunch_ordering/providers/auth_provider.dart';
import 'package:lunch_ordering/screens/sign-up.dart';
import 'package:lunch_ordering/shared_preferences.dart';
import 'package:lunch_ordering/components.dart';
import 'package:flutter/material.dart';
import 'package:lunch_ordering/constants.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignIn extends StatefulWidget {
  const SignIn({Key? key}) : super(key: key);

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  static final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: 'signin');

  @override
  void initState() {
    super.initState();
    Provider.of<AuthProvider>(context, listen: false).loadUserNumberPassword();
    getToken();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                left: width * 0.05, right: width * 0.05, top: width * 0.05),
            child: Form(
              key: _formKey,
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
                          const Text('BSL ORDERS', style: KMENUTextStyle),
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
                            offset: const Offset(0, 4),
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
                            const Center(
                              child: Text('Nice to see you again',
                                  style: KNTSYAStyle),
                            ),
                            SizedBox(height: height * 0.05),
                            const Text('Phone Number', style: KButtonTextStyle),
                            SizedBox(height: height * 0.01),
                            NumberForm(
                              focusedBorder: true,
                              controller: authProvider.numberController,
                              label: 'Phone Number',
                              type: TextInputType.number,
                              colour: const Color(0xFFF2F2F2),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Password', style: KButtonTextStyle),
                                TextButton(
                                  onPressed: () {
                                    authProvider.numberController.text.isEmpty
                                        ? showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return alertDialog(context, () {
                                                Navigator.pop(context);
                                              },
                                                  'No Number Provided',
                                                  'Please Provide a valid phone number',
                                                  'Exit');
                                            })
                                        : authProvider.forgotPassword(context);
                                  },
                                  child: const Text('Forgot Password ?',
                                      style: KForgotPassword),
                                ),
                              ],
                            ),
                            PasswordForm(
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
                                  style: KForgotPassword,
                                ),
                              ],
                            ),
                            Center(
                              child: SizedBox(
                                width: width,
                                height: height * 0.1,
                                child: Button(
                                  text: 'Continue',
                                  isLoading: authProvider.isLoading,
                                  onPressed: () async {
                                    if (_formKey.currentState!.validate()) {
                                      authProvider.changeStatus(true);
                                      authProvider.login(context);
                                      //formKey.currentState?.reset();
                                    }
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top: width * 0.025),
                              child: const Divider(
                                thickness: 1.0,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text(
                                  'Don\'t have an account?',
                                  style: KForgotPassword,
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const SignUp()),
                                    );
                                  },
                                  child: const Text(
                                    'Sign up now',
                                    style: KForgotPassword,
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
