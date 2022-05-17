import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lunch_ordering/providers/food_providers.dart';
import 'package:lunch_ordering/constants.dart';
import 'package:lunch_ordering/components.dart';
import 'package:provider/provider.dart';

import 'main-screen.dart';

class ViewHistory extends StatefulWidget {
  const ViewHistory({Key? key}) : super(key: key);

  @override
  State<ViewHistory> createState() => _ViewHistoryState();
}

class _ViewHistoryState extends State<ViewHistory> {
  var height, width;
  bool isLoading = false;
  DateTime _selectedDate = DateTime.now();
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    bool isSelected = false;
    final foodProvider = Provider.of<FoodProvider>(context);

    return Scaffold(
      key: scaffoldKey,
      drawer: MainScreenDrawer(),
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
              FutureBuilder<List<Orders>?>(
                  future: foodProvider.getPreviousOrders(context),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Orders>? orders = snapshot.data;
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: orders?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                                child: Padding(
                              padding:
                                  const EdgeInsets.fromLTRB(30, 20, 20, 20),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: height * 0.04),
                                  Text('Food: ' + orders![index].food!,
                                      style: KCardTextStyle),
                                  SizedBox(height: height * 0.04),
                                  Text('Drink: ' + orders[index].drink!,
                                      style: KCardTextStyle),
                                  SizedBox(height: height * 0.04),
                                  Text('Comment: ' + orders[index].comment!,
                                      style: KCardTextStyle),
                                ],
                              ),
                            ));
                          });
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0),
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
