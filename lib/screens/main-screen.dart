import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lunch_ordering/components.dart';
import 'package:lunch_ordering/constants.dart';
import 'package:lunch_ordering/screens/loading-screen.dart';
import 'package:lunch_ordering/screens/splash-screen.dart';
import '../providers/auth_provider.dart';
import '../providers/food_providers.dart';
import '../shared_preferences.dart';
import 'package:provider/provider.dart';

int? selected = 0;

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  var size, height, width;
  int selectedIndex = 0;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  late FoodProvider foodVm;

  @override
  void initState() {
    super.initState();
    getToken();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    bool isSelected = false;
    final foodProvider = Provider.of<FoodProvider>(context, listen: true);

    Widget build1(BuildContext context) {
      return ListView.builder(
          shrinkWrap: true,
          itemCount: foodProvider.menu.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                title: Text(foodProvider.menu[index].Option!),
                selected: index == selectedIndex,
                onTap: () {
                  setState(() {
                    selectedIndex = index;
                    selected = foodProvider.menu[index].id!;
                  });
                },
                selectedTileColor: darkblue,
                selectedColor: Colors.white,
              ),
            );
          });
    }

    return Scaffold(
      key: scaffoldKey,
      drawer: MainScreenDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              left: width * 0.05, right: width * 0.05, top: width * 0.05),
          child: Stack(children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset('images/img.png',
                        height: width * 0.1, width: width * 0.1),
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
              padding: EdgeInsets.only(top: width * 0.20),
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
                  padding: EdgeInsets.only(
                      left: width * 0.05,
                      right: width * 0.05,
                      bottom: width * 0.05),
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
                            build1(context),
                            SizedBox(height: height * 0.02),
                            Text('Comments',
                                style: TextStyle(
                                    fontFamily: 'Poppins',
                                    color: darkblue,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold)),
                            SizedBox(height: height * 0.02),
                            Container(
                                decoration: BoxDecoration(
                                  color: darkblue,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                height: width * 0.3,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                      cursorColor: Colors.white,
                                      controller:
                                          foodProvider.textFieldController,
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                      decoration: InputDecoration(
                                          border: InputBorder.none,
                                          focusedBorder: InputBorder.none)),
                                )),
                            SizedBox(height: height * 0.02),
                            Center(
                              child: Container(
                                width: width * 0.5,
                                height: height * 0.1,
                                child: Button(
                                  onPressed: () async {
                                    foodProvider.orderFood(context);
                                  },
                                  isLoading: foodProvider.isloading,
                                  text: 'Place Order',
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: height * 0.02),
                      ]),
                ),
              ),
            ),
            Positioned(
              left: width * 0.33,
              top: width * 0.13,
              child: Container(
                child: Image.asset('images/img_1.png',
                    height: width * 0.175, width: width * 0.25),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}
