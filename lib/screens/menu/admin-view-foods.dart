import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lunch_ordering/components.dart';
import 'package:lunch_ordering/constants.dart';
import 'package:lunch_ordering/providers/food_providers.dart';
import 'package:provider/provider.dart';

import '../../Domain/foods.dart';
import '../../Domain/menu.dart';
import '../main-screen.dart';

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
  late FoodProvider foodVm;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    Provider.of<FoodProvider>(context, listen: true).fetchAllFoods(context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    final foodProvider = Provider.of<FoodProvider>(context);
    bool isSelected = false;
    return Scaffold(
      key: scaffoldKey,
      drawer: const NavDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              top: width * 0.05, left: width * 0.05, right: width * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              bslOrdersRow(width: width, scaffoldKey: scaffoldKey),
              SizedBox(height: height * 0.02),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    FutureBuilder<List<Foods>?>(
                        future: foodProvider.fetchAllFoods(context),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List<Foods>? menu = snapshot.data;
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
                          return Center(
                            child: CircularProgressIndicator(
                              color: blue,
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
        onPressed: () {},
        backgroundColor: darkBlue,
        label: Text('Add Food'),
        icon: const Icon(Icons.add),
      ),
    );
  }
}
