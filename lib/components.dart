import 'package:flutter/material.dart';
import 'package:lunch_ordering/constants.dart';
import 'package:lunch_ordering/providers/auth_provider.dart';
import 'package:lunch_ordering/providers/food_providers.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

AlertDialog alertDialogLogin(http.Response response) {
  if (response.statusCode == 401) {
    return const AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      title: Icon(Icons.cancel, color: Colors.red),
      content: Center(child: Text('Invalid Login Credentials, Try Again')),
    );
  } else {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(5.0))),
      title: Column(
        children: const [
          Icon(Icons.cancel, color: Colors.red),
          Text('Something went wrong. Try Again'),
        ],
      ),
      content: Text(response.body),
    );
  }
}

AlertDialog alertDialog(BuildContext context, onPressed, String textHeader,
    textContent, String textButton) {
  return AlertDialog(
      shape: const RoundedRectangleBorder(
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

Widget row(String type, bool isLoading, onPressed) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(type, style: KMENUTextStyle),
      Button(text: 'ADD', isLoading: isLoading, onPressed: onPressed)
    ],
  );
}

Widget column(isEmpty, context, String type, chipType, onPressed, isLoading) {
  return Column(
    children: [
      isEmpty
          ? Column(
              children: [
                Text('No $type Added', style: KNTSYAStyle),
                Button(
                  onPressed: onPressed,
                  text: 'ADD',
                  isLoading: isLoading,
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
                          labelStyle: const TextStyle(color: Colors.white),
                          backgroundColor: darkBlue,
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
  Navigator.pushNamedAndRemoveUntil(context, '/signin', (route) => false);
}

class NavDrawer extends StatelessWidget {
  const NavDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context, listen: true);

    return Drawer(
      child: Padding(
        padding: const EdgeInsets.only(top: 60.0),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
                hoverColor: darkBlue,
                leading: const Icon(Icons.menu),
                title:
                    const Text('Menu', style: TextStyle(fontFamily: 'Poppins')),
                onTap: () {
                  Navigator.pushNamed(context, '/allMenus');
                }),
            authProvider.user.type == 'admin'
                ? ListTile(
                    hoverColor: Colors.white,
                    leading: const Icon(Icons.dashboard),
                    title: const Text(
                      'Order Food',
                      style: TextStyle(fontFamily: 'Poppins'),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, '/third');
                    })
                : const SizedBox(),
            authProvider.user.type == 'admin'
                ? ListTile(
                    hoverColor: darkBlue,
                    leading: const Icon(Icons.remove_red_eye),
                    title: const Text('View All Users',
                        style: TextStyle(fontFamily: 'Poppins')),
                    onTap: () {
                      Navigator.pushNamed(context, '/allUsers');
                    })
                : const SizedBox(),
            authProvider.user.type == 'admin'
                ? ListTile(
                    hoverColor: darkBlue,
                    leading: const Icon(Icons.approval),
                    title: const Text('Approvals',
                        style: TextStyle(fontFamily: 'Poppins')),
                    onTap: () {
                      Navigator.pushNamed(context, '/adminApprovalRequests');
                    })
                : const SizedBox(),
            authProvider.user.type == 'admin'
                ? ListTile(
                    hoverColor: darkBlue,
                    leading: const Icon(Icons.add),
                    title: const Text('Add User',
                        style: TextStyle(fontFamily: 'Poppins')),
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, '/adminAddUser', (route) => false);
                    })
                : const SizedBox(),
            ListTile(
                hoverColor: darkBlue,
                leading: const Icon(Icons.local_pizza),
                title: const Text('View Foods',
                    style: TextStyle(fontFamily: 'Poppins')),
                onTap: () {
                  Navigator.pushNamed(context, '/adminOrders');
                }),
            ListTile(
                hoverColor: darkBlue,
                leading: const Icon(Icons.wine_bar),
                title: const Text('View Drinks',
                    style: TextStyle(fontFamily: 'Poppins')),
                onTap: () {
                  Navigator.pushNamed(context, '/allDrinks');
                }),
            ListTile(
                hoverColor: darkBlue,
                leading: const Icon(Icons.fastfood),
                title: const Text('View Orders',
                    style: TextStyle(fontFamily: 'Poppins')),
                onTap: () {
                  Navigator.pushNamed(context, '/adminViewOrders');
                }),
            ListTile(
                hoverColor: darkBlue,
                leading: const Icon(Icons.logout),
                title: const Text('Logout',
                    style: TextStyle(fontFamily: 'Poppins')),
                onTap: () {
                  logout(context);
                }),
          ],
        ),
      ),
    );
  }
}

class PasswordForm extends StatefulWidget {
  const PasswordForm({Key? key, required this.passwordcontroller})
      : super(key: key);
  final TextEditingController passwordcontroller;

  @override
  _PasswordFormState createState() => _PasswordFormState();
}

class _PasswordFormState extends State<PasswordForm> {
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
          border: const OutlineInputBorder(
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
              const TextStyle(fontFamily: 'Poppins', color: Color(0xFF808080)),
          labelText: "Enter Password",
          floatingLabelStyle: TextStyle(color: blue),
          focusedBorder: const OutlineInputBorder(
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
                Icon(icon, size: height * 0.05, color: darkBlue),
                SizedBox(height: height * 0.04),
                Text(text,
                    style: TextStyle(
                        color: darkBlue,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w500,
                        fontSize: 20)),
                SizedBox(height: height * 0.04),
                Text(number,
                    style: TextStyle(
                        color: darkBlue,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 20)),
              ],
            ),
          )),
    );
  }
}

class FormLocal extends StatefulWidget {
  FormLocal(
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
  State<FormLocal> createState() => _FormLocalState();
}

class _FormLocalState extends State<FormLocal> {
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
            hintStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            contentPadding: widget.contentPadding,
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(width: 2.0)),
            labelStyle: const TextStyle(
                fontFamily: 'Poppins', color: Color(0xFF808080)),
            labelText: widget.label,
            floatingLabelStyle: TextStyle(color: blue),
            focusedBorder: widget.focusedBorder
                ? const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  )
                : null),
      ),
    );
  }
}

class TextInput extends StatefulWidget {
  const TextInput({
    Key? key,
    required this.controller,
  }) : super(key: key);

  final TextEditingController controller;

  @override
  State<TextInput> createState() => _TextInputState();
}

class _TextInputState extends State<TextInput> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
        cursorColor: Colors.white,
        controller: widget.controller,
        style: const TextStyle(
          color: Colors.white,
        ),
        decoration: const InputDecoration(
            border: InputBorder.none, focusedBorder: InputBorder.none));
  }
}

class NumberForm extends StatefulWidget {
  NumberForm(
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
  State<NumberForm> createState() => _NumberFormState();
}

class _NumberFormState extends State<NumberForm> {
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
            hintStyle: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            contentPadding: widget.contentPadding,
            border: const OutlineInputBorder(
                borderRadius: BorderRadius.zero,
                borderSide: BorderSide(width: 2.0)),
            labelStyle: const TextStyle(
                fontFamily: 'Poppins', color: Color(0xFF808080)),
            labelText: widget.label,
            floatingLabelStyle: TextStyle(color: blue),
            focusedBorder: widget.focusedBorder
                ? const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue, width: 2.0),
                  )
                : null),
      ),
    );
  }
}

class Button extends StatefulWidget {
  Button(
      {this.onPressed,
      required this.text,
      required this.isLoading,
      this.color});

  final String text;
  Function()? onPressed;
  bool isLoading = false;
  Color? color;

  @override
  State<Button> createState() => _ButtonState();
}

class _ButtonState extends State<Button> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: ElevatedButton(
        style: widget.color != null
            ? ButtonStyle(
                backgroundColor:
                    MaterialStateProperty.all<Color>(widget.color!),
              )
            : ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(darkBlue),
              ),
        onPressed: widget.onPressed,
        child: widget.isLoading
            ? const SizedBox(
                width: 15.0,
                height: 15.0,
                child: CircularProgressIndicator(
                  color: Colors.white,
                  strokeWidth: 2.0,
                ),
              )
            : Text(
                widget.text,
                style: const TextStyle(
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
              hoverColor: Colors.white,
              leading: const Icon(Icons.dashboard),
              title: const Text(
                'Order Food',
                style: KCardTextStyle,
              ),
              onTap: () {
                Navigator.popAndPushNamed(context, '/third');
              }),
          ListTile(
              hoverColor: darkBlue,
              leading: const Icon(Icons.history),
              title: const Text(
                'History',
                style: KCardTextStyle,
              ),
              onTap: () {
                Navigator.popAndPushNamed(context, '/history');
              }),
          //SizedBox(height: height * 0.55),
          ListTile(
              hoverColor: darkBlue,
              leading: const Icon(Icons.logout),
              title: const Text(
                'Logout',
                style: KCardTextStyle,
              ),
              onTap: () {
                logout(context);
              }),
        ],
      ),
    ));
  }
}

class CustomWidget extends StatefulWidget {
  const CustomWidget({
    Key? key,
    required this.food,
    required this.drink,
    required this.date,
  }) : super(key: key);
  final String food, drink, date;
  @override
  State<CustomWidget> createState() => _CustomWidgetState();
}

class _CustomWidgetState extends State<CustomWidget> {
  @override
  Widget build(BuildContext context) {
    final foodProvider = Provider.of<FoodProvider>(context, listen: true);

    return AlertDialog(
        scrollable: true,
        content: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
          child: Column(
            children: <Widget>[
              const Text('You already placed an order for', style: KTextStyle3),
              Text(widget.food, style: KTextStyle3),
              Text('and ${widget.drink} on', style: KTextStyle3),
              Text(' ${widget.date} ', style: KTextStyle3),
              const Text('Do you want to replace order?', style: KTextStyle3),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Button(
                      text: 'Yes',
                      isLoading: false,
                      onPressed: () {
                        foodProvider.changeUpdateOrder(true);
                        Navigator.pop(context);
                      },
                      color: Colors.green,
                    ),
                    Button(
                      text: 'No',
                      isLoading: false,
                      onPressed: () {
                        foodProvider.changeUpdateOrder(false);
                        Navigator.pop(context);
                      },
                      color: Colors.red,
                    ),
                  ])
            ],
          ),
        ));
  }
}
