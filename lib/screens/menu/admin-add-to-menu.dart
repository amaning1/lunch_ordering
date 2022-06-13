import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lunch_ordering/components.dart';
import 'package:lunch_ordering/constants.dart';
import 'package:lunch_ordering/Domain/ChipData.dart';
import 'package:provider/provider.dart';
import '../../Domain/allMenus.dart';
import '../../Domain/drinks.dart';
import '../../Domain/foods.dart';
import '../../Domain/menu.dart';
import '../../providers/food_providers.dart';
import '../main-screen.dart';

int? selected = 0;

class AdminAdd extends StatefulWidget {
  const AdminAdd({Key? key}) : super(key: key);

  @override
  State<AdminAdd> createState() => _AdminAddState();
}

class _AdminAddState extends State<AdminAdd> {
  var height, width;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final List<ChipData> allChips = [];
  int? selectedIndex;

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
      body: Padding(
        padding: EdgeInsets.only(
            top: height * 0.05, left: width * 0.05, right: width * 0.05),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset('images/img.png', height: 40, width: 45),
                    SizedBox(width: width * 0.05),
                    Text('ADD', style: KMENUTextStyle),
                    SizedBox(width: width * 0.02),
                    Text(foodProvider.type, style: KCardTextStyle),
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
            foodProvider.type == 'Food'
                ? Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      spacing: 10,
                      children: foodProvider.foodChips
                          .map((chip) => Chip(
                                key: ValueKey(chip.id),
                                label: Text(chip.name),
                                labelStyle: TextStyle(color: Colors.white),
                                backgroundColor: darkBlue,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 7, horizontal: 10),
                                deleteIconColor: Colors.red,
                                onDeleted: () =>
                                    foodProvider.removeFood(chip.id),
                              ))
                          .toList(),
                    ),
                  )
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Wrap(
                      spacing: 10,
                      children: foodProvider.drinkChips
                          .map((chip) => Chip(
                                key: ValueKey(chip.id),
                                label: Text(chip.name),
                                labelStyle:
                                    const TextStyle(color: Colors.white),
                                backgroundColor: darkBlue,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 7, horizontal: 10),
                                deleteIconColor: Colors.red,
                                onDeleted: () =>
                                    foodProvider.removeDrink(chip.id),
                              ))
                          .toList(),
                    ),
                  ),
            foodProvider.type == 'Food'
                ? Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: foodProvider.allFoods.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              title: Text(foodProvider.allFoods[index].Option!),
                              selected: foodProvider.foodIDS
                                  .contains(foodProvider.allFoods[index].id),
                              onTap: () {
                                setState(() {
                                  foodProvider.foodIDS.contains(
                                          foodProvider.allFoods[index].id)
                                      ? foodProvider.removeFood(
                                          foodProvider.allFoods[index].id)
                                      : foodProvider.addFood(
                                          foodProvider.allFoods,
                                          index,
                                          selectedIndex);
                                  print(foodProvider.foodIDS);
                                  //selected = menu[index].id!;
                                });
                              },
                              selectedTileColor: darkBlue,
                              selectedColor: Colors.white,
                            ),
                          );
                        }),
                  )
                : Expanded(
                    child: ListView.builder(
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: foodProvider.allDrinks.length,
                        itemBuilder: (BuildContext context, int index) {
                          return Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: ListTile(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              title:
                                  Text(foodProvider.allDrinks[index].Option!),
                              selected: foodProvider.drinkIDS
                                  .contains(foodProvider.allDrinks[index].id),
                              onTap: () {
                                setState(() {
                                  foodProvider.drinkIDS.contains(
                                          foodProvider.allDrinks[index].id)
                                      ? foodProvider.removeDrink(
                                          foodProvider.allDrinks[index].id)
                                      : foodProvider.addDrink(
                                          foodProvider.allDrinks,
                                          index,
                                          selectedIndex);
                                });
                              },
                              selectedTileColor: darkBlue,
                              selectedColor: Colors.white,
                            ),
                          );
                        }),
                  ),
            SizedBox(height: height * 0.03),
            Container(
              width: width * 0.4,
              child: Button(
                text: 'Add to Menu',
                isLoading: foodProvider.isLoading,
                onPressed: () {
                  Navigator.pushNamedAndRemoveUntil(
                      context, '/addMenu', (route) => false);
                },
              ),
            ),
            SizedBox(height: height * 0.05),
          ],
        ),
      ),
    );
  }
}
