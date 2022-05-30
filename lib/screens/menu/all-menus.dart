import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lunch_ordering/constants.dart';
import 'package:lunch_ordering/components.dart';
import '../../Domain/orders.dart';
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
                      Text('MENU', style: KMENUTextStyle),
                      SizedBox(width: width * 0.02),
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
              // FutureBuilder<List<Orders>?>(
              //     future: foodProvider.getOrders(context),
              //     builder: (context, snapshot) {
              //       if (snapshot.hasData) {
              //         List<Orders>? orders = snapshot.data;
              //         return ListView.builder(
              //             shrinkWrap: true,
              //             itemCount: orders?.length,
              //             itemBuilder: (BuildContext context, int index) {
              //               return Card(
              //                   child: Padding(
              //                 padding:
              //                     const EdgeInsets.fromLTRB(30, 20, 20, 20),
              //                 child: Column(
              //                   crossAxisAlignment: CrossAxisAlignment.start,
              //                   children: <Widget>[
              //                     // Text('Name: ' + orders![index].name?,
              //                     //     style: KCardTextStyle),
              //                     SizedBox(height: height * 0.04),
              //                     Text('Food: ' + orders![index].food,
              //                         style: KCardTextStyle),
              //                     SizedBox(height: height * 0.04),
              //                     Text('Drink: ' + orders[index].drink,
              //                         style: KCardTextStyle),
              //                     SizedBox(height: height * 0.04),
              //                     Text('Comment: ' + orders[index].comment!,
              //                         style: KCardTextStyle),
              //                   ],
              //                 ),
              //               ));
              //             });
              //       } else if (snapshot.hasError) {
              //         return Text("${snapshot.error}");
              //       }
              //       return Card(
              //         shape: RoundedRectangleBorder(
              //           borderRadius: BorderRadius.circular(10.0),
              //         ),
              //       );
              //     }),
              Button(
                onPressed: () {
                  Navigator.pushNamed(context, '/addMenu');
                },
                isLoading: foodProvider.isloading,
                text: 'Add Menu',
              )
            ],
          ),
        ),
      ),
    );
  }
}
