import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lunch_ordering/components.dart';
import 'package:lunch_ordering/constants.dart';
import '../providers/food_providers.dart';
import '../shared_preferences.dart';
import 'package:provider/provider.dart';

int? menuIDx;
int? selected = 0;
bool checkBox = false;

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  String value = '';
  var size, height, width;
  int selectedIndex = 0;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  String token = '';
  late FoodProvider foodVm;

  @override
  void initState() {
    super.initState();
    getToken();
    Future.delayed(Duration.zero, () {
      foodVm = Provider.of<FoodProvider>(context, listen: true)
          .fetchFood(context) as FoodProvider;
      foodVm = Provider.of<FoodProvider>(context, listen: true).getMenuID()
          as FoodProvider;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    height = size.height;
    width = size.width;
    bool isSelected = false;
    final foodProvider = Provider.of<FoodProvider>(context, listen: true);

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
                                future: foodProvider.fetchFood(context),
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
                                  controller: foodProvider.textFieldController,
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
                                    foodProvider.orderFood(context);
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
