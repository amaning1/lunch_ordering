import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Domain/orders.dart';
import '../../components.dart';
import '../../constants.dart';
import '../../providers/food_providers.dart';
import '../../shared_preferences.dart';

class AdminViewOrders extends StatefulWidget {
  const AdminViewOrders({Key? key}) : super(key: key);

  @override
  State<AdminViewOrders> createState() => _AdminViewOrdersState();
}

class _AdminViewOrdersState extends State<AdminViewOrders> {
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
    var height, width;
    var scaffoldKey = GlobalKey<ScaffoldState>();
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    final foodProvider = Provider.of<FoodProvider>(context);

    return Scaffold(
      key: scaffoldKey,
      drawer: NavDrawer(),
      //resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              top: width * 0.05, left: width * 0.05, right: width * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              bslOrdersRow(width: width, scaffoldKey: scaffoldKey),
              SizedBox(height: height * 0.2),
              foodProvider.listOrders.isEmpty
                  ? ChefCards(
                      height: height,
                      width: width,
                      number: '0',
                      text: 'Orders',
                      icon: Icons.fastfood)
                  : ordersWidget(
                      orders: foodProvider.listOrders,
                      height: height,
                      width: width)
            ],
          ),
        ),
      ),
    );
  }
}

class ordersWidget extends StatelessWidget {
  ordersWidget({
    Key? key,
    required this.orders,
    required this.height,
    required this.width,
  }) : super(key: key);

  final List<Orders>? orders;
  var height;
  var width;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        shrinkWrap: true,
        itemCount: orders?.length,
        itemBuilder: (BuildContext context, int index) {
          return Card(
              child: Padding(
            padding: EdgeInsets.only(
                top: width * 0.05, left: width * 0.05, right: width * 0.05),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Name: ' + orders![index].name!, style: KCardTextStyle),
                SizedBox(height: height * 0.04),
                Text('Food: ' + orders![index].food, style: KCardTextStyle),
                SizedBox(height: height * 0.04),
                Text('Drink: ' + orders![index].drink, style: KCardTextStyle),
                SizedBox(height: height * 0.04),
                Text('Comment: ' + orders![index].comment!,
                    style: KCardTextStyle),
              ],
            ),
          ));
        });
  }
}
