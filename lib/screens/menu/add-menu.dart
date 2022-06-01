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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      Text('MENU', style: KCardTextStyle),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => scaffoldKey.currentState?.openDrawer(),
                  ),
                ],
              ),
              SizedBox(height: height * 0.05),
              row('Food', foodProvider.isLoading, () {
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
                  child: column(foodProvider.foodChips.isEmpty, context, 'Food',
                      foodProvider.foodChips, () {
                    foodProvider.typeFood();
                    Navigator.pushNamed(context, '/adminAdd');
                  }, foodProvider.isLoading),
                ),
              ),
              SizedBox(height: height * 0.03),
              row('Drink', foodProvider.isLoading, () {
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
                  child: column(foodProvider.drinkChips.isEmpty, context,
                      'Drink', foodProvider.drinkChips, () {
                    foodProvider.typeDrink();
                    Navigator.pushNamed(context, '/adminAdd');
                  }, foodProvider.isLoading),
                ),
              ),
              foodProvider.drinkChips.isEmpty
                  ? SizedBox(height: height * 0.5)
                  : SizedBox(),
              Container(
                width: width * 0.4,
                child: Button(
                  text: 'Add to Menu',
                  isLoading: foodProvider.menuLoading,
                  onPressed: () {
                    foodProvider.addMenu(
                        foodProvider.foodIDS, foodProvider.drinkIDS, context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
