import 'package:flutter/material.dart';
import 'package:lunch_ordering/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

List<String> food = <String>[];
List<String> drink = <String>[];
AlertDialog alertDialog(http.Response response) {
  return AlertDialog(
    shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(10.0))),
    title: Column(
      children: [
        Icon(Icons.cancel, color: Colors.red),
        Text('Error code ' + ' ' + response.statusCode.toString()),
      ],
    ),
    content: Text(response.body),
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

class optionFood extends StatelessWidget {
  const optionFood({Key? key, required this.controller, required this.label})
      : super(key: key);

  final TextEditingController controller;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 10, bottom: 10),
      child: TextFormField(
        controller: controller,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.justify,
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xFFF2F2F2),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none),
          labelStyle: TextStyle(fontFamily: 'Roboto', color: Color(0xFF808080)),
          labelText: label,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
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

class InputField extends StatefulWidget {
  InputField(
      {this.icon,
      required this.label,
      required this.parameter,
      required this.isObscure,
      required this.controller});

  String label = '';
  String parameter = '';
  bool isObscure = false;
  final Widget? icon;
  TextEditingController controller;

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  final controller = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10.0),
      child: TextFormField(
        controller: widget.controller,
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'This field is required';
          }
        },
        keyboardType: TextInputType.emailAddress,
        textAlign: TextAlign.center,
        obscureText: widget.isObscure,
        decoration: InputDecoration(
          filled: true,
          fillColor: Color(0xFFF2F2F2),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide.none),
          suffixIcon: widget.icon,
          labelStyle: TextStyle(fontFamily: 'Roboto', color: Color(0xFF808080)),
          labelText: widget.label,
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blue, width: 2.0),
            borderRadius: BorderRadius.circular(10.0),
          ),
        ),
      ),
    );
  }
}
