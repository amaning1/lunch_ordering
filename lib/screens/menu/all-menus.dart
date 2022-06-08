import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lunch_ordering/providers/menu_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lunch_ordering/constants.dart';
import 'package:lunch_ordering/components.dart';
import '../../providers/food_providers.dart';
import '../../shared_preferences.dart';

class AllMenus extends StatefulWidget {
  @override
  State<AllMenus> createState() => _AllMenusState();
}

class _AllMenusState extends State<AllMenus> {
  var height, width;
  bool isLoading = false;
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  late FoodProvider foodVm;

  @override
  void initState() {
    super.initState();

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
    final menuProvider = Provider.of<MenuProvider>(context);

    var foodList = ListView.builder(
        shrinkWrap: true,
        itemCount: menuProvider.allMenu.length,
        itemBuilder: (context, index) {
          var foodMenus = menuProvider.allMenu[index];
          return SizedBox(
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 13.0, top: 5.0),
                    child: Text(
                      foodMenus.menuId.toString(),
                      style: KTextStyle3,
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: foodMenus.drinks.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(foodMenus.drinks[index].drinkName),
                            );
                          },
                        ),
                      ),
                      Expanded(
                        child: ListView.builder(
                          shrinkWrap: true,
                          itemCount: foodMenus.foods.length,
                          itemBuilder: (context, index) {
                            return ListTile(
                              title: Text(foodMenus.foods[index].foodName),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });

    return Scaffold(
      key: scaffoldKey,
      drawer: NavDrawer(),
      //resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(top: 20, left: 20, right: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              bslMenu(width: width, scaffoldKey: scaffoldKey),
              //SizedBox(height: width * 0.5),
              foodList,
              SizedBox(
                width: width,
                child: Button(
                  onPressed: () {
                    Navigator.pushNamed(context, '/addMenu');
                  },
                  isLoading: menuProvider.isLoading,
                  text: 'Add Menu',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
