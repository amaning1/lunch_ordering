import 'dart:developer';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lunch_ordering/components.dart';
import 'package:lunch_ordering/constants.dart';
import 'package:lunch_ordering/Domain/ChipData.dart';
import 'package:provider/provider.dart';

import '../providers/food_providers.dart';
import 'main-screen.dart';

int? selected = 0;

class AdminAdd extends StatefulWidget {
  const AdminAdd({Key? key}) : super(key: key);

  @override
  State<AdminAdd> createState() => _AdminAddState();
}

class _AdminAddState extends State<AdminAdd> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var height, width;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  final List<ChipData> allChips = [];
  List<int> foodIDS = [];
  TextEditingController foodcontroller = TextEditingController();
  TextEditingController drinkcontroller = TextEditingController();
  int selectedIndex = 0;

  int index = 0;

  @override
  void initState() {
    super.initState();

    final List<ChipData> allChips = [];
    List<int> foodIDS = [];
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
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Image.asset('images/img.png', height: 40, width: 45),
                    SizedBox(width: width * 0.03),
                    Text('BSL',
                        style: const TextStyle(
                            fontFamily: 'Poppins',
                            fontWeight: FontWeight.w600,
                            fontSize: 20)),
                    SizedBox(width: width * 0.02),
                    Text('ORDERS',
                        style: TextStyle(
                            color: darkblue,
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
            SizedBox(height: height * 0.05),
            Row(
              children: [
                Text('WELCOME CHEF',
                    style: TextStyle(
                        color: darkblue,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w600,
                        fontSize: 20)),
              ],
            ),
            Text('Add Food',
                style: TextStyle(
                    color: darkblue,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 16)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 10,
                children: allChips
                    .map((chip) => Chip(
                          key: ValueKey(chip.id),
                          label: Text(chip.name),
                          labelStyle: TextStyle(color: Colors.white),
                          backgroundColor: darkblue,
                          padding: const EdgeInsets.symmetric(
                              vertical: 7, horizontal: 10),
                          deleteIconColor: Colors.red,
                          onDeleted: () => _deleteChip(chip.id),
                        ))
                    .toList(),
              ),
            ),
            FutureBuilder<List<Menu>?>(
                future: foodProvider.fetchAllFoods(context),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    List<Menu>? menu = snapshot.data;
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
                                selected: index == selectedIndex,
                                onTap: () {
                                  setState(() {
                                    allChips.add(ChipData(
                                        id: menu[index].id!,
                                        name: menu[index].Option!));
                                    foodIDS.add(menu[index].id!);
                                    selectedIndex = index;
                                    selected = menu[index].id!;
                                  });
                                },
                                selectedTileColor: darkblue,
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
            Container(
              width: width * 0.4,
              child: Button(
                text: 'Add to Menu',
                isLoading: foodProvider.isloading,
                onPressed: () {
                  foodProvider.addMenu(foodIDS, context);
                },
              ),
            ),
            SizedBox(height: height * 0.03),
            Text('Add Drink',
                style: TextStyle(
                    color: darkblue,
                    fontFamily: 'Poppins',
                    fontWeight: FontWeight.w600,
                    fontSize: 16)),
            TextFormField(
              controller: drinkcontroller,
            ),
            Container(
              width: width * 0.4,
              child: Button(
                text: 'Add to Menu',
                isLoading: false,
                onPressed: () {},
              ),
            ),
            SizedBox(height: height * 0.05),
          ],
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
