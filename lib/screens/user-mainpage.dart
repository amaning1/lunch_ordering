import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lunch_ordering/components.dart';
import 'package:lunch_ordering/constants.dart';
import 'package:lunch_ordering/screens/loading-screen.dart';
import 'package:lunch_ordering/screens/splash-screen.dart';
import '../Domain/user.dart';
import '../providers/auth_provider.dart';
import '../providers/food_providers.dart';
import '../shared_preferences.dart';
import 'package:provider/provider.dart';

class UserMain extends StatefulWidget {
  @override
  State<UserMain> createState() => _UserMainState();
}

class _UserMainState extends State<UserMain> {
  var size, height, width;
  int? selectedFoodIndex;
  int? selectedDrinkIndex;

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
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      key: scaffoldKey,
      drawer: MainScreenDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              left: width * 0.05, right: width * 0.05, top: width * 0.05),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Image.asset('images/img.png',
                            height: width * 0.1, width: width * 0.1),
                        SizedBox(width: width * 0.05),
                        Text('BSL ORDERS', style: KMENUTextStyle),
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
                          onPressed: () =>
                              scaffoldKey.currentState?.openDrawer(),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: height * 0.06),
                Text(
                  'Welcome ${authProvider.user.name},',
                  style: KMENUTextStyle,
                ),
                SizedBox(height: height * 0.14),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/third');
                        },
                        child: Container(
                          height: height * 0.35,
                          width: height * 0.24,
                          decoration: BoxDecoration(
                            color: grayish,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/third');
                                },
                                icon: Icon(Icons.fastfood),
                                iconSize: height * 0.15,
                              ),
                              Text(
                                'Order Food',
                                style: KButtonTextStyle,
                              )
                            ],
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.pushReplacementNamed(context, '/history');
                        },
                        child: Container(
                          height: height * 0.35,
                          width: height * 0.24,
                          decoration: BoxDecoration(
                            color: grayish,
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pushReplacementNamed(
                                      context, '/history');
                                },
                                icon: Icon(Icons.history),
                                iconSize: height * 0.15,
                              ),
                              Text(
                                'History',
                                style: KButtonTextStyle,
                              )
                            ],
                          ),
                        ),
                      ),
                    ]),
                SizedBox(height: height * 0.10),
              ]),
        ),
      ),
    );
  }
}
