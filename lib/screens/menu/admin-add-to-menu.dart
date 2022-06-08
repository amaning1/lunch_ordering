import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lunch_ordering/components.dart';
import 'package:lunch_ordering/constants.dart';
import 'package:lunch_ordering/Domain/ChipData.dart';
import 'package:provider/provider.dart';
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
        padding: EdgeInsets.all(width * 0.05),
        child: Column(
          children: [
            SizedBox(height: height * 0.050),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset('images/img.png', height: 40, width: 45),
                    SizedBox(width: width * 0.03),
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
                ? FutureBuilder<List<Foods>?>(
                    future: foodProvider.fetchAllFoods(context),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Foods>? menu = snapshot.data;
                        return Expanded(
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: menu?.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: ListTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    title: Text(menu![index].Option!),
                                    selected: foodProvider.foodIDS
                                        .contains(menu[index].id),
                                    onTap: () {
                                      setState(() {
                                        foodProvider.foodIDS
                                                .contains(menu[index].id)
                                            ? foodProvider
                                                .removeFood(menu[index].id)
                                            : foodProvider.addFood(
                                                menu, index, selectedIndex);
                                        print(foodProvider.foodIDS);
                                        //selected = menu[index].id!;
                                      });
                                    },
                                    selectedTileColor: darkBlue,
                                    selectedColor: Colors.white,
                                  ),
                                );
                              }),
                        );
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          color: blue,
                        ),
                      );
                    })
                : FutureBuilder<List<Foods>?>(
                    future: foodProvider.fetchAllDrinks(context),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        List<Foods>? menu = snapshot.data;
                        return Expanded(
                          child: ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: menu?.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: ListTile(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    title: Text(menu![index].Option!),
                                    selected: foodProvider.drinkIDS
                                        .contains(menu[index].id),
                                    onTap: () {
                                      setState(() {
                                        foodProvider.drinkIDS
                                                .contains(menu[index].id)
                                            ? foodProvider
                                                .removeDrink(menu[index].id)
                                            : foodProvider.addDrink(
                                                menu, index, selectedIndex);
                                      });
                                    },
                                    selectedTileColor: darkBlue,
                                    selectedColor: Colors.white,
                                  ),
                                );
                              }),
                        );
                      } else if (snapshot.hasError) {
                        return Text("${snapshot.error}");
                      }
                      return Center(
                        child: CircularProgressIndicator(
                          color: blue,
                        ),
                      );
                    }),
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
