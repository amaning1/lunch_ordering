import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

var date = DateTime.now();
var today = DateFormat('EEEE').format(date);

class MenuScreen extends StatefulWidget {
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  TextEditingController textFieldController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;

  late User loggedInUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    final user = _auth.currentUser!;
    try {
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }

  String foodChoice = 'Fufu and beans';
  String drinkChoice = 'Asaana';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            _firestore.collection(today).add({
              'Food': foodChoice,
              'Drink': drinkChoice,
              'User': loggedInUser.email,
              'Date': date,
              'Comments': textFieldController.text,
            });
            showDialog<String>(
                context: context,
                builder: (BuildContext context) => AlertDialog(
                        title: Text('Your Order Has Been Placed'),
                        actions: <Widget>[
                          IconButton(
                              onPressed: () {
                                //Navigator.pop(context);
                                Navigator.pushNamed(context, '/');
                              },
                              icon: Icon(
                                Icons.close,
                                color: Colors.white,
                              ))
                        ]));
          },
          label: Text(
            'Order Food',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blueAccent,
          icon: Icon(Icons.add, color: Colors.white),
        ),
        body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.only(left: 50),
                        padding: EdgeInsets.all(12.0),
                        child: Text('$today\'s Lunch Menu',
                            style: TextStyle(
                              fontWeight: FontWeight.w400,
                              fontSize: 50.0,
                            )),
                      ),
                    ),
                  )
                ],
              ),
              Container(
                margin: EdgeInsets.all(20.0),
                padding: EdgeInsets.all(3.0),
                height: 50.0,
                width: 50.0,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: DropdownButton<String>(
                    value: foodChoice,
                    onChanged: (String? newValue) {
                      setState(() {
                        foodChoice = newValue!;
                      });
                    },
                    underline: DropdownButtonHideUnderline(child: Container()),
                    items: <String>[
                      'Fufu and beans',
                      'Rice and stew',
                      'Fried rice',
                      'Gob3',
                      'Waakye'
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(20.0),
                padding: EdgeInsets.all(3.0),
                height: 50.0,
                width: 50.0,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Center(
                  child: DropdownButton<String>(
                    value: drinkChoice,
                    onChanged: (String? newValue) {
                      setState(() {
                        drinkChoice = newValue!;
                      });
                    },
                    underline: DropdownButtonHideUnderline(child: Container()),
                    items: <String>[
                      'Asaana',
                      'Pine Ginger',
                      'Sobolo',
                      'Watermelon and beetrot',
                    ].map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          value,
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.0,
                            color: Colors.black,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(3),
                height: 50,
                width: 50,
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                                  title: Text('Please type your comment'),
                                  content: TextField(
                                    controller: textFieldController,
                                  ),
                                  actions: <Widget>[
                                    IconButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        icon: Icon(Icons.close))
                                  ]));
                    },
                    child: Text('ANY COMMENTS?',
                        style: TextStyle(color: Colors.blueAccent)),
                    // 'ANY COMMENTS?',
                    // style: TextStyle(
                    //   color: Colors.blueAccent,
                    // ),
                  ),
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.blueAccent),
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ]));
  }
}
