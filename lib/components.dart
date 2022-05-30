import 'package:flutter/material.dart';
import 'package:lunch_ordering/constants.dart';
import 'package:lunch_ordering/providers/food_providers.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import 'Domain/ChipData.dart';

List<String> food = <String>[];
List<String> drink = <String>[];
AlertDialog alertDialogLogin(http.Response response) {
  if (response.statusCode == 401) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      title: Icon(Icons.cancel, color: Colors.red),
      content: Center(child: Text('Invalid Login Credentials, Try Again')),
    );
  } else
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      title: Column(
        children: [
          Icon(Icons.cancel, color: Colors.red),
          Text('Something went wrong. Try Again'),
        ],
      ),
      content: Text(response.body),
    );
}

AlertDialog alertDialog(BuildContext context, onPressed, String textHeader,
    String textContent, String textButton) {
  return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      title: Text(textHeader, style: KAlertHeader),
      //insetPadding: EdgeInsets.symmetric(vertical: 240),
      content: Text(textContent, style: KAlertContent),
      actions: [
        TextButton(
          child: Text(
            textButton,
            style: KAlertButton,
          ),
          onPressed: onPressed,
        ),
      ]);
}

Widget row(String type, bool isloading, onPressed) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(type, style: menuLarge),
      Button(text: 'ADD', isLoading: isloading, onPressed: onPressed)
    ],
  );
}

Widget column(isEmpty, context, String type, chipType, onPressed, isloading) {
  return Column(
    children: [
      isEmpty
          ? Column(
              children: [
                Text('No $type Added', style: KNTSYAStyle),
                Button(
                  onPressed: onPressed,
                  text: 'ADD',
                  isLoading: isloading,
                ),
              ],
            )
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 10,
                children: chipType
                    .map<Widget>((chip) => Chip(
                          label: Text(chip.name),
                          key: ValueKey(chip.id),
                          labelStyle: TextStyle(color: Colors.white),
                          backgroundColor: darkblue,
                          padding: const EdgeInsets.symmetric(
                              vertical: 7, horizontal: 10),
                        ))
                    .toList(),
              ),
            ),
    ],
  );
}

void logout(context) async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  sharedPreferences.remove('token');
  sharedPreferences.remove('phone_number');
  sharedPreferences.remove('password');
  sharedPreferences.remove('remember_me');
  print(sharedPreferences.getBool('remember_me'));
  Navigator.pushNamed(context, '/signin');
}

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(top: 60.0),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
                hoverColor: darkblue,
                leading: Icon(Icons.menu),
                title:
                    const Text('Menu', style: TextStyle(fontFamily: 'Poppins')),
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/allMenus', (route) => false);
                }),
            ListTile(
                hoverColor: darkblue,
                leading: Icon(Icons.dashboard),
                title: const Text('Dashboard',
                    style: TextStyle(fontFamily: 'Poppins')),
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/fourth', (route) => false);
                }),
            ListTile(
                hoverColor: darkblue,
                leading: Icon(Icons.approval),
                title: const Text('Approvals',
                    style: TextStyle(fontFamily: 'Poppins')),
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/adminApprovalRequests', (route) => false);
                }),
            ListTile(
                hoverColor: darkblue,
                leading: Icon(Icons.add),
                title: const Text('Add User',
                    style: TextStyle(fontFamily: 'Poppins')),
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/adminAddUser', (route) => false);
                }),
            ListTile(
                hoverColor: darkblue,
                leading: Icon(Icons.history),
                title: const Text('View Foods',
                    style: TextStyle(fontFamily: 'Poppins')),
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/adminOrders', (route) => false);
                }),
            ListTile(
                hoverColor: darkblue,
                leading: Icon(Icons.fastfood),
                title: const Text('View Orders',
                    style: TextStyle(fontFamily: 'Poppins')),
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/adminViewOrders', (route) => false);
                }),
            ListTile(
                hoverColor: darkblue,
                leading: Icon(Icons.logout),
                title: const Text('Logout',
                    style: TextStyle(fontFamily: 'Poppins')),
                onTap: () {
                  logout(context);
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/signin', (route) => false);
                }),
          ],
        ),
      ),
    );
  }
}

class passwordForm extends StatefulWidget {
  const passwordForm({Key? key, required this.passwordcontroller})
      : super(key: key);
  final TextEditingController passwordcontroller;

  @override
  _passwordFormState createState() => _passwordFormState();
}

class _passwordFormState extends State<passwordForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: TextFormField(
        controller: widget.passwordcontroller,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          } else {
            return null;
          }
        },
        keyboardType: TextInputType.visiblePassword,
        textAlign: TextAlign.left,
        obscureText: isObscure,
        decoration: InputDecoration(
          border: OutlineInputBorder(
              borderRadius: BorderRadius.zero,
              borderSide: BorderSide(width: 2.0)),
          suffixIcon: IconButton(
            icon: Icon(isObscure ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                isObscure = !isObscure;
              });
            },
          ),
          labelStyle:
              TextStyle(fontFamily: 'Poppins', color: Color(0xFF808080)),
          labelText: "Enter Password",
          floatingLabelStyle: TextStyle(color: blue),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
          ),
        ),
      ),
    );
  }
}

class ChefCards extends StatelessWidget {
  ChefCards(
      {Key? key,
      this.height,
      required this.number,
      required this.text,
      this.width,
      required this.icon})
      : super(key: key);

  final height;
  final width;
  String text;
  String number;
  IconData? icon;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height * 0.3,
      width: width,
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(30, 20, 20, 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Icon(icon, size: height * 0.05, color: darkblue),
                SizedBox(height: height * 0.04),
                Text(text,
                    style: TextStyle(
                        color: darkblue,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 20)),
                SizedBox(height: height * 0.04),
                Text(number,
                    style: TextStyle(
                        color: darkblue,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 20)),
              ],
            ),
          )),
    );
  }
}

class form extends StatefulWidget {
  form(
      {Key? key,
      required this.focusedBorder,
      required this.controller,
      this.label,
      this.hintText,
      required this.type,
      this.colour,
      this.contentPadding})
      : super(key: key);

  final TextEditingController controller;
  final String? label;
  final String? hintText;
  final TextInputType type;
  Color? colour;
  EdgeInsets? contentPadding;
  bool focusedBorder;

  @override
  State<form> createState() => _formState();
}

class _formState extends State<form> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: TextFormField(
        controller: widget.controller,
        validator: (value) {
          if (value!.isEmpty) {
            return 'This field is required';
          }
        },
        keyboardType: widget.type,
        textAlign: TextAlign.justify,
        decoration: InputDecoration(
            fillColor: widget.colour,
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            contentPadding: widget.contentPadding,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(width: 2.0)),
            labelStyle:
                TextStyle(fontFamily: 'Poppins', color: Color(0xFF808080)),
            labelText: widget.label,
            floatingLabelStyle: TextStyle(color: blue),
            focusedBorder: widget.focusedBorder
                ? OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  )
                : null),
      ),
    );
  }
}

class numberForm extends StatefulWidget {
  numberForm(
      {Key? key,
      required this.focusedBorder,
      required this.controller,
      this.label,
      this.hintText,
      required this.type,
      this.colour,
      this.contentPadding})
      : super(key: key);

  final TextEditingController controller;
  final String? label;
  final String? hintText;
  final TextInputType type;
  Color? colour;
  EdgeInsets? contentPadding;
  bool focusedBorder;

  @override
  State<numberForm> createState() => _numberFormState();
}

class _numberFormState extends State<numberForm> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 10),
      child: TextFormField(
        controller: widget.controller,
        validator: (value) {
          if (value!.length != 10) {
            return 'Number is less than 10';
          } else if (value.isEmpty) {
            return 'This field is required';
          }
        },
        keyboardType: widget.type,
        textAlign: TextAlign.justify,
        decoration: InputDecoration(
            fillColor: widget.colour,
            hintText: widget.hintText,
            hintStyle: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            contentPadding: widget.contentPadding,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(width: 2.0)),
            labelStyle:
                TextStyle(fontFamily: 'Poppins', color: Color(0xFF808080)),
            labelText: widget.label,
            floatingLabelStyle: TextStyle(color: blue),
            focusedBorder: widget.focusedBorder
                ? OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  )
                : null),
      ),
    );
  }
}

class Button extends StatefulWidget {
  Button({this.onPressed, required this.text, required this.isLoading});

  final String text;
  Function()? onPressed;
  bool isLoading = false;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all<Color>(darkblue),
        ),
        onPressed: widget.onPressed,
        child: widget.isLoading
            ? SizedBox(
                width: 15.0,
                height: 15.0,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.0,
                ),
              )
            : Text(
                widget.text,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontFamily: 'Poppins',
                ),
              ),
      ),
    );
  }
}

class MainScreenDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Padding(
      padding: const EdgeInsets.only(top: 60.0),
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: [
          ListTile(
              hoverColor: darkblue,
              leading: const Icon(Icons.menu),
              title: const Text(
                'Menu',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              onTap: () {}),
          ListTile(
              hoverColor: Colors.white,
              leading: const Icon(Icons.dashboard),
              title: const Text(
                'Order Food',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              onTap: () {
                Navigator.popAndPushNamed(context, '/third');
              }),
          ListTile(
              hoverColor: darkblue,
              leading: const Icon(Icons.history),
              title: const Text(
                'History',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              onTap: () {
                Navigator.popAndPushNamed(context, '/history');
              }),
          //SizedBox(height: height * 0.55),
          ListTile(
              hoverColor: darkblue,
              leading: const Icon(Icons.logout),
              title: const Text(
                'Logout',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              onTap: () {
                logout(context);
                Navigator.pushNamedAndRemoveUntil(
                    context, '/signin', (route) => false);
              }),
        ],
      ),
    ));
  }
}
