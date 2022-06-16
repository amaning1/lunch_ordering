import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lunch_ordering/providers/menu_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lunch_ordering/constants.dart';
import 'package:lunch_ordering/components.dart';
import '../../providers/food_providers.dart';
import '../../shared_preferences.dart';

class AllMenus extends StatefulWidget {
  const AllMenus({Key? key}) : super(key: key);

  @override
  State<AllMenus> createState() => _AllMenusState();
}

class _AllMenusState extends State<AllMenus> {
  var height, width;
  bool isLoading = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
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

    var foodList = RefreshIndicator(
        onRefresh: () async {
          menuProvider.fetchPreviousMenus(context);
          return Future<void>.delayed(const Duration(seconds: 3));
        },
        child: ListView.builder(
            physics: const AlwaysScrollableScrollPhysics(),
            // shrinkWrap: true,
            itemCount: menuProvider.allMenu.length,
            itemBuilder: (context, index) {
              var foodMenus = menuProvider.allMenu[index];
              var formatDate = DateTime.tryParse(foodMenus.createdAt);
              String date = DateFormat("yyyy-MM-dd").format(formatDate!);
              return SizedBox(
                child: Card(
                  child: Padding(
                    padding: EdgeInsets.only(
                        left: height * 0.04,
                        top: height * 0.03,
                        bottom: height * 0.02),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            RichText(
                                text: TextSpan(
                                    text: foodMenus.menuId.toString() + ' ,',
                                    style: KTextStyle1,
                                    children: const [
                                  TextSpan(
                                      text: '  ' 'Menu Id', style: KTextStyle2)
                                ])),
                            IconButton(
                              onPressed: () {},
                              icon: const Icon(Icons.edit),
                            )
                          ],
                        ),
                        SizedBox(height: height * 0.02),
                        RichText(
                            text: TextSpan(
                                text: date + ' ,',
                                style: KTextStyle1,
                                children: const [
                              TextSpan(
                                  text: '  ' 'Menu date', style: KTextStyle2)
                            ])),
                        SizedBox(height: height * 0.02),
                        Row(
                          children: [
                            Expanded(
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: foodMenus.foods.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title:
                                        Text(foodMenus.foods[index].foodName),
                                  );
                                },
                              ),
                            ),
                            Expanded(
                              child: ListView.builder(
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: foodMenus.drinks.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                    title:
                                        Text(foodMenus.drinks[index].drinkName),
                                  );
                                },
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }));

    return Scaffold(
      key: scaffoldKey,
      drawer: NavDrawer(),
      //resizeToAvoidBottomInset: false,
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Padding(
          padding: EdgeInsets.only(
              top: height * 0.05, left: width * 0.05, right: width * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              bslMenu(width: width, scaffoldKey: scaffoldKey),
              //SizedBox(height: width * 0.5),
              Expanded(child: foodList),
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
