import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';

class MenuScreen extends StatefulWidget {
  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  TextEditingController textFieldController = TextEditingController();

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
          onPressed: () {},
          label: Text(
            'Order Food',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.blueAccent,
          icon: Icon(Icons.add),
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
                          padding: EdgeInsets.all(10.0),
                          child: Text('Wednesday\'s Lunch Menu',
                              style: TextStyle(
                                fontWeight: FontWeight.w400,
                                fontSize: 50.0,
                              ))),
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
                        child: Center(
                          child: Text(
                            value,
                            style: TextStyle(
                              fontSize: 20.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.all(20),
                padding: EdgeInsets.all(10),
                child: Center(
                  child: TextButton(
                    onPressed: () {
                      showDialog<String>(
                          context: context,
                          builder: (BuildContext context) => AlertDialog(
                              title: Text('Please type your comment'),
                              content: TextField(
                                controller: textFieldController,
                              )));
                    },
                    child: Text('ANY COMMENTS'),
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
