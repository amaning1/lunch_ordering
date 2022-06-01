import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lunch_ordering/constants.dart';
import 'package:lunch_ordering/components.dart';
import '../../Domain/menu.dart';
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
              bslMenu(width: width, scaffoldKey: scaffoldKey),
              // FutureBuilder<List<Menu>?>(
              //     future: foodProvider.fetchPreviousMenus(context),
              //     builder: (context, snapshot) {
              //       if (snapshot.hasData) {
              //         List<Menu>? menus = snapshot.data;
              //         return ListView.builder(
              //             shrinkWrap: true,
              //             itemCount: menus?.length,
              //             itemBuilder: (BuildContext context, int index) {
              //               return Padding(
              //                 padding:
              //                     const EdgeInsets.fromLTRB(30, 20, 20, 20),
              //                 child: Card(
              //                   child: Column(
              //                     crossAxisAlignment: CrossAxisAlignment.start,
              //                     children: <Widget>[
              //                       SizedBox(height: height * 0.04),
              //                       Text('Food: ' + menus![index].food_name!,
              //                           style: KCardTextStyle),
              //                       SizedBox(height: height * 0.04),
              //                       Text('Drink: ' + menus[index].drink_name!,
              //                           style: KCardTextStyle),
              //                     ],
              //                   ),
              //                 ),
              //               );
              //             });
              //       } else if (snapshot.hasError) {
              //         return Text("${snapshot.error}");
              //       }
              //       return Center(child: CircularProgressIndicator());
              //     }),
              SizedBox(height: width * 0.5),
              Button(
                onPressed: () {
                  Navigator.pushNamed(context, '/addMenu');
                },
                isLoading: foodProvider.isLoading,
                text: 'Add Menu',
              )
            ],
          ),
        ),
      ),
    );
  }
}
