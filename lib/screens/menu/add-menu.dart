import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lunch_ordering/components.dart';
import 'package:lunch_ordering/constants.dart';
import 'package:lunch_ordering/Domain/ChipData.dart';
import 'package:lunch_ordering/providers/menu_provider.dart';
import 'package:provider/provider.dart';
import '../../Domain/menu.dart';
import '../../providers/food_providers.dart';
import '../main-screen.dart';

int? selected = 0;

class AddMenu extends StatefulWidget {
  @override
  State<AddMenu> createState() => _AddMenuState();
}

class _AddMenuState extends State<AddMenu> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var height, width;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final List<ChipData> allChips = [];
  TextEditingController foodcontroller = TextEditingController();
  TextEditingController drinkcontroller = TextEditingController();
  int selectedIndex = 0;

  int index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    bool isSelected = false;
    final menuProvider = Provider.of<MenuProvider>(context);

    return Scaffold(
      key: scaffoldKey,
      drawer: NavDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              top: width * 0.05, left: width * 0.05, right: width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(height: height * 0.030),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset('images/img.png', height: 40, width: 45),
                      SizedBox(width: width * 0.03),
                      Text('ADD', style: KMENUTextStyle),
                      SizedBox(width: width * 0.02),
                      Text('MENU', style: KCardTextStyle),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => scaffoldKey.currentState?.openDrawer(),
                  ),
                ],
              ),
              SizedBox(height: height * 0.030),
              Container(
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
                  padding: EdgeInsets.all(height * 0.05),
                  child: Column(
                    children: [
                      SizedBox(
                        width: width,
                        child: Button(
                          text: "${selectedDate.toLocal()}".split(' ')[0],
                          isLoading: false,
                          onPressed: () {
                            selectDate(context);
                          },
                        ),
                      ),
                      row('Food', menuProvider.isLoading, () {
                        menuProvider.typeFood();
                        Navigator.pushNamed(context, '/adminAdd');
                      }),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: GestureDetector(
                          onTap: () {
                            menuProvider.typeFood();
                            Navigator.pushNamed(context, '/adminAdd');
                          },
                          child: column(menuProvider.foodChips.isEmpty, context,
                              'Food', menuProvider.foodChips, () {
                            menuProvider.typeFood();
                            Navigator.pushNamed(context, '/adminAdd');
                          }, menuProvider.isLoading),
                        ),
                      ),
                      SizedBox(height: height * 0.03),
                      row('Drink', menuProvider.isLoading, () {
                        menuProvider.typeDrink();
                        Navigator.pushNamed(context, '/adminAdd');
                      }),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            menuProvider.typeDrink();
                            Navigator.pushNamed(context, '/adminAdd');
                          },
                          child: column(menuProvider.drinkChips.isEmpty,
                              context, 'Drink', menuProvider.drinkChips, () {
                            menuProvider.typeDrink();
                            Navigator.pushNamed(context, '/adminAdd');
                          }, menuProvider.isLoading),
                        ),
                      ),
                      menuProvider.drinkChips.isEmpty
                          ? SizedBox(height: height * 0.02)
                          : SizedBox(),
                      SizedBox(
                        width: width,
                        child: Button(
                          text: 'Add to Menu',
                          isLoading: menuProvider.isLoading,
                          onPressed: () {
                            menuProvider.addMenu(menuProvider.foodIDS,
                                menuProvider.drinkIDS, context);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.add(Duration(days: 1)),
      firstDate: DateTime(2022),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
