import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lunch_ordering/constants.dart';
import 'package:lunch_ordering/components.dart';

String token = '';

class AdminPage extends StatefulWidget {
  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  String Option1 = '';
  String Option2 = '';
  String Option3 = '';
  String date = "";
  var height, width;
  bool isLoading = false;
  DateTime _selectedDate = DateTime.now();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TextEditingController option1controller = TextEditingController();
  final TextEditingController option2controller = TextEditingController();
  final TextEditingController option3controller = TextEditingController();
  final TextEditingController option4controller = TextEditingController();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate, // Refer step 1
      firstDate: DateTime(2022),
      lastDate: DateTime(2023),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  Future addMenu() async {
    final response = await http.post(
      Uri.parse('https://bsl-foodapp-backend.herokuapp.com/api/menu'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer" + " " + "$token",
      },
      body: jsonEncode(<String, dynamic>{
        "menu_date": "$_selectedDate",
        "foods": [
          int.parse(option1controller.text),
          int.parse(option2controller.text),
          int.parse(option3controller.text),
          int.parse(option4controller.text),
        ],
        "drinks": [1, 2, 4]
      }),
    );

    if (response.statusCode == 201) {
      String data = response.body;
      print(response.body);
      return AlertDialog(
        title: Text('Added Successfully'),
        content: Text(response.body),
      );
    } else {
      print(response.statusCode);
      print(response.body);
      return AlertDialog(
        title: Text('Error code' + response.statusCode.toString()),
        content: Text(response.body),
      );
    }
  }

  Future getToken() async {
    final SharedPreferences sharedPreferences =
        await SharedPreferences.getInstance();
    var tok = sharedPreferences.getString('token');
    setState(() {
      token = tok!;
    });
    print(token);
  }

  @override
  void initState() {
    super.initState();
    getToken();
    print(_selectedDate);
  }

  @override
  void dispose() {
    option1controller.dispose();
    option2controller.dispose();
    option3controller.dispose();
    option4controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    bool isSelected = false;

    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(top: 60.0),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                  leading: Icon(Icons.menu),
                  title: const Text('Menu',
                      style: TextStyle(fontFamily: 'Poppins')),
                  onTap: () {
                    Navigator.pushNamed(context, '/adminAdd');
                  }),
              ListTile(
                  leading: Icon(Icons.dashboard),
                  title: const Text('Dashboard',
                      style: TextStyle(fontFamily: 'Poppins')),
                  onTap: () {
                    Navigator.pushNamed(context, '/fourth');
                  }),
              ListTile(
                  leading: Icon(Icons.history),
                  title: const Text('Orders',
                      style: TextStyle(fontFamily: 'Poppins')),
                  onTap: () {
                    Navigator.pushNamed(context, '/adminOrders');
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
      ),
      //resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset('images/img.png', height: 40, width: 45),
                      SizedBox(width: width * 0.03),
                      Text('BSL',
                          style: const TextStyle(
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 20)),
                      SizedBox(width: width * 0.02),
                      Text('ORDERS',
                          style: TextStyle(
                              color: darkblue,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              fontSize: 20)),
                    ],
                  ),
                  Row(
                    children: [
                      Switch(
                          value: isSelected,
                          onChanged: (bool value) {
                            isSelected = value;
                          }),
                      IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () => scaffoldKey.currentState?.openDrawer(),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: height * 0.05),
              Row(
                children: [
                  Text('WELCOME CHEF',
                      style: TextStyle(
                          color: darkblue,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w600,
                          fontSize: 20)),
                ],
              ),
              SizedBox(height: height * 0.07),
              ChefCards(
                height: height,
                width: width,
                icon: Icons.add_shopping_cart_outlined,
                number: '8',
                text: 'Total Orders',
              ),
              SizedBox(height: height * 0.05),
              ChefCards(
                height: height,
                width: width,
                icon: Icons.comment,
                number: '8',
                text: 'Total Comments',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
