import 'package:flutter/material.dart';
import 'package:lunch_ordering/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

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
          Text('Error code ' + ' ' + response.statusCode.toString()),
        ],
      ),
      content: Text(response.body),
    );
}

AlertDialog alertDialog() {
  return AlertDialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(5.0))),
    title: Column(
      children: [
        Icon(Icons.cancel, color: Colors.red),
        Text('Uh Oh', style: KNTSYAStyle),
      ],
    ),
    content: Column(
      children: [
        Text('Something went wrong'),
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [Text('Logout', style: KNTSYAStyle)],
        )
      ],
    ),
  );
}

void logout() async {
  final SharedPreferences sharedPreferences =
      await SharedPreferences.getInstance();
  sharedPreferences.remove('token');
  sharedPreferences.remove('phone_number');
  sharedPreferences.remove('password');
  sharedPreferences.remove('remember_me');
  print(sharedPreferences.getBool('remember_me'));
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
                leading: Icon(Icons.menu),
                title:
                    const Text('Menu', style: TextStyle(fontFamily: 'Poppins')),
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/adminAdd', (route) => false);
                }),
            ListTile(
                leading: Icon(Icons.dashboard),
                title: const Text('Dashboard',
                    style: TextStyle(fontFamily: 'Poppins')),
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/fourth', (route) => false);
                }),
            ListTile(
                leading: Icon(Icons.history),
                title: const Text('History',
                    style: TextStyle(fontFamily: 'Poppins')),
                onTap: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/adminOrders', (route) => false);
                }),
            ListTile(
                leading: Icon(Icons.logout),
                title: const Text('Logout',
                    style: TextStyle(fontFamily: 'Poppins')),
                onTap: () {
                  logout();
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

class User {
  int? type;
  String? name;
  String? phone_number;
  //String? token;
  String? status;

  User({this.type, this.name, this.phone_number, this.status});

  factory User.fromJson(Map<String, dynamic> responseData) {
    return User(
      type: responseData['type'],
      name: responseData['name'],
      phone_number: responseData['phone_number'],
      status: responseData['status'],
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
  const MainScreenDrawer({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
        child: Padding(
      padding: const EdgeInsets.only(top: 30.0),
      child: ListView(
        shrinkWrap: true,
        padding: EdgeInsets.zero,
        children: [
          ListTile(
              leading: const Icon(Icons.menu),
              title: const Text(
                'Menu',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              onTap: () {}),
          ListTile(
              leading: const Icon(Icons.dashboard),
              title: const Text(
                'Order Food',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              onTap: () {
                Navigator.popAndPushNamed(context, '/third');
              }),
          ListTile(
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
              leading: const Icon(Icons.logout),
              title: const Text(
                'Logout',
                style: TextStyle(fontFamily: 'Poppins'),
              ),
              onTap: () {
                logout();
                Navigator.pushNamedAndRemoveUntil(
                    context, '/signin', (route) => false);
              }),
        ],
      ),
    ));
  }
}
