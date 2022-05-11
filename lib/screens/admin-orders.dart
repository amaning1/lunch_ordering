import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lunch_ordering/components.dart';
import 'package:lunch_ordering/constants.dart';
import 'package:lunch_ordering/providers/food_providers.dart';
import 'package:provider/provider.dart';

import 'main-screen.dart';

class AdminOrders extends StatefulWidget {
  const AdminOrders({Key? key}) : super(key: key);

  @override
  State<AdminOrders> createState() => _AdminOrdersState();
}

class _AdminOrdersState extends State<AdminOrders> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var height, width;
  int selectedIndex = 0;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    final foodProvider = Provider.of<FoodProvider>(context);
    bool isSelected = false;
    return Scaffold(
      key: scaffoldKey,
      drawer: NavDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FutureBuilder<List<Menu>?>(
                        future: foodProvider.fetchAllFoods(context),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<Menu>? menu = snapshot.data;
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: menu?.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10.0),
                                    ),
                                    child: ListTile(
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      title: Text(menu![index].Option!),
                                      subtitle:
                                          Text(menu[index].id!.toString()),
                                      selected: index == selectedIndex,
                                      trailing: IconButton(
                                        onPressed: () {
                                          foodProvider
                                              .deleteFood(menu[index].id!);
                                          setState(() {
                                            menu;
                                          });
                                        },
                                        icon: Icon(Icons.delete),
                                      ),
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
