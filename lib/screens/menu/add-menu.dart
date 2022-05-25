import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lunch_ordering/components.dart';
import 'package:lunch_ordering/constants.dart';
import 'package:lunch_ordering/Domain/ChipData.dart';
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
    final foodProvider = Provider.of<FoodProvider>(context);

    return Scaffold(
      key: scaffoldKey,
      drawer: NavDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset('images/img.png', height: 40, width: 45),
                      SizedBox(width: width * 0.03),
                      Text('ADD', style: KMENUTextStyle),
                      SizedBox(width: width * 0.02),
                      Text('MENU', style: KMENUTextStyle),
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
              row('Food', foodProvider.isloading, () {
                foodProvider.typeFood();
                Navigator.pushNamed(context, '/adminAdd');
              }),
              Padding(
                padding: const EdgeInsets.only(top: 10, bottom: 10),
                child: GestureDetector(
                  onTap: () {
                    foodProvider.typeFood();
                    Navigator.pushNamed(context, '/adminAdd');
                  },
                  child: column(foodProvider.FoodChips.isEmpty, context, 'Food',
                      foodProvider.FoodChips, () {
                    foodProvider.typeFood();
                    Navigator.pushNamed(context, '/adminAdd');
                  }, foodProvider.isloading),
                ),
              ),
              SizedBox(height: height * 0.03),
              row('Drink', foodProvider.isloading, () {
                foodProvider.typeDrink();
                Navigator.pushNamed(context, '/adminAdd');
              }),
              Padding(
                padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                child: GestureDetector(
                  onTap: () {
                    foodProvider.typeDrink();
                    Navigator.pushNamed(context, '/adminAdd');
                  },
                  child: column(foodProvider.DrinkChips.isEmpty, context,
                      'Drink', foodProvider.DrinkChips, () {
                    foodProvider.typeDrink();
                    Navigator.pushNamed(context, '/adminAdd');
                  }, foodProvider.isloading),
                ),
              ),
              Container(
                width: width * 0.4,
                child: Button(
                  text: 'Add to Menu',
                  isLoading: foodProvider.isloading,
                  onPressed: () {
                    foodProvider.addMenu(
                        foodProvider.foodIDS, foodProvider.drinkIDS, context);
                  },
                ),
              ),
              SizedBox(height: height * 0.05),
            ],
          ),
        ),
      ),
    );
  }

  void _deleteChip(int id) {
    setState(() {
      allChips.removeWhere((element) => element.id == id);
    });
  }
}
