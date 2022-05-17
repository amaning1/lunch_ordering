import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lunch_ordering/constants.dart';
import 'package:lunch_ordering/components.dart';
import '../providers/food_providers.dart';
import '../shared_preferences.dart';

class AdminPage extends StatefulWidget {
  @override
  State<AdminPage> createState() => _AdminPageState();
}

class _AdminPageState extends State<AdminPage> {
  var height, width;
  bool isLoading = false;
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
      //resizeToAvoidBottomInset: false,
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
              SizedBox(height: height * 0.07),
              ChefCards(
                height: height,
                width: width,
                icon: Icons.add_shopping_cart_outlined,
                number: '8',
                text: 'Total Orders',
              ),
              SizedBox(height: height * 0.05),
              ChefCards(
                height: height,
                width: width,
                icon: Icons.comment,
                number: '8',
                text: 'Total Comments',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
