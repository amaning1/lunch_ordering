import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lunch_ordering/controllers/providers/approval_provider.dart';
import 'package:lunch_ordering/controllers/providers/auth_provider.dart';
import 'package:lunch_ordering/controllers/providers/food_providers.dart';
import 'package:provider/provider.dart';
import '/constants.dart';
import '/controllers/providers/menu_provider.dart';

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
    if (Provider.of<AuthProvider>(context, listen: false).user.type ==
        'admin') {
      Provider.of<ApprovalProvider>(context, listen: false)
          .getAllUsers(context);
      Provider.of<ApprovalProvider>(context, listen: false)
          .getAllApprovalRequests(context);
    }
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
