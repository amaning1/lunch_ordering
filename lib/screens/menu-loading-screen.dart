import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lunch_ordering/providers/food_providers.dart';
import 'package:provider/provider.dart';
import '../constants.dart';
import '../providers/menu_provider.dart';
import 'main-screen.dart';

class MenuLoadingScreen extends StatefulWidget {
  const MenuLoadingScreen({Key? key}) : super(key: key);

  @override
  State<MenuLoadingScreen> createState() => _MenuLoadingScreenState();
}

class _MenuLoadingScreenState extends State<MenuLoadingScreen> {
  late FoodProvider foodVm;

  @override
  void initState() {
    Provider.of<MenuProvider>(context, listen: false)
        .fetchPreviousMenus(context);
    Provider.of<FoodProvider>(context, listen: false).getOrders(context);
    Provider.of<FoodProvider>(context, listen: false).fetchAllFoods(context);
    Provider.of<FoodProvider>(context, listen: false).fetchAllDrinks(context);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Padding(
          padding: EdgeInsets.all(height * 0.08),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('images/img.png',
                  height: width * 0.2, width: width * 0.2),
              const SizedBox(width: 5),
              const Text('BSL ORDERS', style: KMENUTextStyle),
            ],
          ),
        ),
      ],
    ));
  }
}
