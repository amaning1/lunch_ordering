import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lunch_ordering/components.dart';
import 'package:lunch_ordering/constants.dart';
import 'package:lunch_ordering/providers/food_providers.dart';
import 'package:provider/provider.dart';

import '../../Domain/allMenus.dart';
import '../../Domain/drinks.dart';
import '../../Domain/foods.dart';
import '../../Domain/menu.dart';
import '../main-screen.dart';

class ViewDrinks extends StatefulWidget {
  const ViewDrinks({Key? key}) : super(key: key);

  @override
  State<ViewDrinks> createState() => _ViewDrinksState();
}

class _ViewDrinksState extends State<ViewDrinks> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var height, width;
  int selectedIndex = 0;
  late FoodProvider foodVm;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    final foodProvider = Provider.of<FoodProvider>(context);
    TextEditingController drink = TextEditingController();
    var scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      drawer: const NavDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              top: height * 0.05, left: width * 0.05, right: width * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              bslOrdersRow(width: width, scaffoldKey: scaffoldKey),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListView.builder(
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
                              subtitle: Text(
                                  foodProvider.allDrinks[index].id.toString()),
                              trailing: IconButton(
                                onPressed: () {
                                  foodProvider.deleteFood(
                                      foodProvider.allDrinks[index].id);
                                  setState(() {
                                    foodProvider.allDrinks;
                                  });
                                },
                                icon: Icon(Icons.delete),
                              ),
                            ),
                          );
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(5.0))),
                  title: Text('Add Food', style: KAlertHeader),
                  //insetPadding: EdgeInsets.symmetric(vertical: 240),
                  content: TextFormField(
                    controller: drink,
                  ),
                  actions: [
                    TextButton(
                      child: const Text(
                        'Add',
                        style: KAlertButton,
                      ),
                      onPressed: () {
                        foodProvider.addNewDrink(drink, context);
                      },
                    ),
                  ]);
            },
          );
        },
        backgroundColor: darkBlue,
        label: Text('Add Drink'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
