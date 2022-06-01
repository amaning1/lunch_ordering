import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lunch_ordering/constants.dart';
import 'package:lunch_ordering/components.dart';
import '../../Domain/foods.dart';
import '../../Domain/orders.dart';
import '../../providers/food_providers.dart';
import '../../shared_preferences.dart';

class AdminPage extends StatefulWidget {
  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  var height, width;
  bool isTapped = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  late FoodProvider foodVm;

  @override
  void initState() {
    super.initState();
    // Future.delayed(Duration.zero, (){
    //   foodVm = Provider.of<FoodProvider>(context).getOrders(menu_id, context)
    // });
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
                      Text('BSL', style: KMENUTextStyle),
                      SizedBox(width: width * 0.02),
                      Text('ORDERS', style: KCardTextStyle),
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
                  Text('WELCOME', style: KMENUTextStyle),
                ],
              ),
              SizedBox(height: height * 0.02),
              FutureBuilder<List<Orders>?>(
                  future: foodProvider.getOrders(context),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Orders>? menu = snapshot.data;
                      return isTapped
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: menu?.length,
                              itemBuilder: (BuildContext context, int index) {
                                return Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.fromLTRB(
                                        height * 0.04,
                                        height * 0.02,
                                        height * 0.04,
                                        height * 0.02),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text('Name: ${menu![index].name!}',
                                            style: KTextStyle3),
                                        Text(
                                          'Food: ${menu[index].food}',
                                          style: KTextStyle3,
                                        ),
                                        Text('Drink: ${menu[index].drink}',
                                            style: KTextStyle3),
                                        Text('Comment: ${menu[index].comment!}',
                                            style: KTextStyle3)
                                      ],
                                    ),
                                  ),
                                );
                              })
                          : GestureDetector(
                              onTap: () {
                                setState(() {
                                  isTapped = true;
                                });
                              },
                              child: ChefCards(
                                height: height,
                                width: width,
                                icon: Icons.add_shopping_cart_outlined,
                                number: menu!.length.toString(),
                                text: 'Total Orders',
                              ),
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
            ],
          ),
        ),
      ),
    );
  }
}
