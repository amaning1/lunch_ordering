import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lunch_ordering/components.dart';

String token = '';

class Admin extends StatefulWidget {
  @override
  State<Admin> createState() => _AdminState();
}

class _AdminState extends State<Admin> {
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
                    Navigator.pushNamed(context, '/third');
                  }),
              ListTile(
                  leading: Icon(Icons.dashboard),
                  title: const Text('Dashboard',
                      style: TextStyle(fontFamily: 'Poppins')),
                  onTap: () {}),
              ListTile(
                  leading: Icon(Icons.history),
                  title: const Text('History',
                      style: TextStyle(fontFamily: 'Poppins')),
                  onTap: () {}),
              ListTile(
                  leading: Icon(Icons.logout),
                  title: const Text('Logout',
                      style: TextStyle(fontFamily: 'Poppins')),
                  onTap: () {
                    Navigator.pushNamed(context, '/signin');
                  }),
            ],
          ),
        ),
      ),
      //resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Stack(children: <Widget>[
          Positioned(
              left: 350,
              top: 40,
              child: IconButton(
                icon: Icon(Icons.menu),
                onPressed: () => scaffoldKey.currentState?.openDrawer(),
              )),
          Form(
            key: formKey,
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  SizedBox(height: height * 0.10),
                  Button(
                    onPressed: () {
                      _selectDate(context);
                    },
                    isLoading: false,
                    text:
                        'Date Selected: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                  ),
                  optionFood(
                    controller: option1controller,
                    label: 'Option1',
                  ),
                  optionFood(controller: option2controller, label: 'Option2'),
                  optionFood(controller: option3controller, label: 'Option3'),
                  optionFood(controller: option4controller, label: 'Option4'),

                  Button(
                    isLoading: isLoading,
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        setState(() {
                          isLoading = true;
                        });
                        // Future.delayed(Duration(seconds: 30), () {
                        //   setState(() {
                        //     isLoading = false;
                        //   });
                        // });
                        addMenu();
                      }
                    },
                    text: 'Add Menu',
                  ),
                  const Padding(
                    padding: EdgeInsets.only(
                        left: 23, right: 23, top: 7, bottom: 13),
                    child: Divider(
                      thickness: 1.0,
                    ),
                  ),

                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('images/img.png', height: 40, width: 45),
                        const SizedBox(width: 5),
                        const Text('BSL ORDERS',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              fontFamily: 'NeueMachina',
                            )),
                      ],
                    ),
                  ),
                  // SizedBox(height: height * 0.10),
                  // const Center(
                  //   child: Padding(
                  //     padding: EdgeInsets.only(left: 8.0, right: 8.0),
                  //     child: const Text('\u00a9 Copyright NSP DEVS 2021',
                  //         style: TextStyle(
                  //           fontFamily: 'NeueMachina',
                  //         )),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
