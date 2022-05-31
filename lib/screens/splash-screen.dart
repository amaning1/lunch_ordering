import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lunch_ordering/providers/food_providers.dart';
import 'package:provider/provider.dart';

import '../constants.dart';
import 'main-screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late FoodProvider foodVm;

  @override
  void initState() {
    Future.delayed(Duration.zero, () {
      foodVm = Provider.of<FoodProvider>(context, listen: false)
          .fetchFood(context) as FoodProvider;
    });
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
