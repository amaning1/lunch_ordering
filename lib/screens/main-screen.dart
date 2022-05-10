import 'dart:async';
import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lunch_ordering/components.dart';
import 'package:lunch_ordering/constants.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

import '../APIs.dart';
import '../shared_preferences.dart';

int? menuIDx;
int? selected = 0;
bool checkBox = false;

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  TextEditingController textFieldController = TextEditingController();
  String value = '';
  var size, height, width;
  int selectedIndex = 0;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  String token = '';

  Future<List<Menu>?> fetchFood() async {
    await getToken();
    List<Menu>? list;
    final response = await http.get(
      Uri.parse(AppURL.getMenu),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer" + " " + "$token",
      },
    );

    if (response.statusCode == 200) {
      String data = response.body;

      var rest = jsonDecode(data)['data']['menu']['foods'] as List;
      print(rest);
      list = rest.map<Menu>((json) => Menu.fromJson(json)).toList();
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Column(
              children: [
                const Icon(Icons.cancel, color: Colors.red),
                Text('Error code fetch food' +
                    ' ' +
                    response.statusCode.toString()),
              ],
            ),
            content: Text(response.body),
          );
        },
      );
      print(response.statusCode);
      print(response);
    }
    return list;
  }

  Future getMenuID() async {
    await getToken();
    final response =
        await http.get(Uri.parse(AppURL.getMenu), headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
      HttpHeaders.authorizationHeader: "Bearer" + " " + "$token",
    });

    if (response.statusCode == 200) {
      String data = response.body;
      final int menu_id = jsonDecode(data)['data']['menu']['menu_id'];
      menuIDx = menu_id;
      print(menuIDx);
    } else {
      print(response.statusCode);
      print(response);
    }
    return menuIDx;
  }

  Future orderFood(String comment) async {
    await getToken();
    final response = await http.post(
      Uri.parse('https://bsl-foodapp-backend.herokuapp.com/api/order'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
        HttpHeaders.authorizationHeader: "Bearer" + " " + "$token",
      },
      body: jsonEncode(<String, dynamic>{
        'menu_id': menuIDx,
        'food_id': selected.toString(),
        'drink_id': "14",
        'comment': comment
      }),
    );
    if (response.statusCode == 202) {
      print(response.body);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(const Radius.circular(10.0))),
            title: Column(
              children: [
                const Icon(Icons.check, color: Colors.green),
              ],
            ),
            content: const Text('Your order has been placed'),
          );
        },
      );
    } else {
      print(response.statusCode);
      print(response.body);
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0))),
            title: Column(
              children: [
                const Icon(Icons.cancel, color: Colors.red),
                Text('Error code' + ' ' + response.statusCode.toString()),
              ],
            ),
            content: Text(response.body),
          );
        },
      );
    }
  }

  // Future getToken() async {
  //   final SharedPreferences sharedPreferences =
  //       await SharedPreferences.getInstance();
  //   var tok = sharedPreferences.getString('token');
  //
  //   token = tok!;
  // }

  @override
  void initState() {
    super.initState();
    getToken();
    fetchFood();
    getMenuID();
  }

  @override
  void dispose() {
    textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    bool isSelected = false;

    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
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
                  'Dashboard',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                onTap: () {}),
            ListTile(
                leading: const Icon(Icons.history),
                title: const Text(
                  'History',
                  style: TextStyle(fontFamily: 'Poppins'),
                ),
                onTap: () {}),
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
      )),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, top: 30),
          child: Stack(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset('images/img.png', height: 40, width: 45),
                    SizedBox(width: width * 0.05),
                    Text('BSL ORDERS',
                        style: const TextStyle(
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
            SizedBox(height: height * 0.10),
            Padding(
              padding: const EdgeInsets.only(top: 80),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      spreadRadius: 4,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, right: 20, bottom: 10),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        SizedBox(height: height * 0.08),
                        Center(
                          child: Text('Bon Appétit',
                              style: TextStyle(
                                  fontFamily: 'Poppins',
                                  color: darkblue,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 20)),
                        ),
                        SizedBox(height: height * 0.02),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Choose Food',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: darkblue,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                            FutureBuilder<List<Menu>?>(
                                future: fetchFood(),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    List<Menu>? menu = snapshot.data;
                                    return ListView.builder(
                                        shrinkWrap: true,
                                        itemCount: menu?.length,
                                        itemBuilder:
                                            (BuildContext context, int index) {
                                          return Card(
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10.0),
                                            ),
                                            child: ListTile(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              title: Text(menu![index].Option!),
                                              selected: index == selectedIndex,
                                              onTap: () {
                                                setState(() {
                                                  selectedIndex = index;
                                                  selected = menu[index].id!;
                                                });
                                              },
                                              selectedTileColor: darkblue,
                                              selectedColor: Colors.white,
                                            ),
                                          );
                                        });
                                  } else if (snapshot.hasError) {
                                    return Text("${snapshot.error}");
                                  }
                                  return LinearProgressIndicator(
                                    color: blue,
                                  );
                                }),
                            SizedBox(height: height * 0.02),
                            Text('Comments',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: darkblue,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: height * 0.02),
                            Container(
                              child: form(
                                  focusedBorder: false,
                                  contentPadding:
                                      EdgeInsets.symmetric(vertical: 40),
                                  controller: textFieldController,
                                  type: TextInputType.text,
                                  colour: darkblue),
                            ),
                            SizedBox(height: height * 0.02),
                            Center(
                              child: Container(
                                width: width * 0.5,
                                height: height * 0.07,
                                child: ElevatedButton(
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            darkblue),
                                  ),
                                  onPressed: () async {
                                    orderFood(textFieldController.text);
                                  },
                                  child: Text(
                                    'Place Order',
                                    textAlign: TextAlign.right,
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ]),
                ),
              ),
            ),
            Positioned(
              left: 120,
              top: 45,
              child: Container(
                child: Image.asset('images/img_1.png', height: 70, width: 100),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

class Menu {
  int? id;
  String? Option;

  Menu({this.id, this.Option});

  factory Menu.fromJson(Map<String, dynamic> responseData) {
    return Menu(
      id: responseData['id'],
      Option: responseData['name'],
    );
  }
}
