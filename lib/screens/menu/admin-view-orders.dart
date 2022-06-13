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
  var scaffoldKey = GlobalKey<ScaffoldState>();

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
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    final foodProvider = Provider.of<FoodProvider>(context);

    return Scaffold(
      key: scaffoldKey,
      drawer: NavDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              top: height * 0.05, left: width * 0.05, right: width * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              bslOrdersRow(width: width, scaffoldKey: scaffoldKey),
              foodProvider.listOrders.isEmpty
                  ? ChefCards(
                      height: height,
                      width: width,
                      number: '0',
                      text: 'Orders',
                      icon: Icons.fastfood)
                  : RefreshIndicator(
                      onRefresh: () async {
                        foodProvider.getOrders(context);
                        return Future<void>.delayed(const Duration(seconds: 3));
                      },
                      child: ordersWidget(
                          orders: foodProvider.listOrders,
                          height: height,
                          width: width),
                    )
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
        physics: const AlwaysScrollableScrollPhysics(),
        shrinkWrap: true,
        itemCount: orders?.length,
        itemBuilder: (BuildContext context, int index) {
          var foodCount = orders![index].food.length;
          var drinkCount = orders![index].drink.length;
          var commentCount = orders![index].comment?.length;
          print(foodCount);
          print(drinkCount);
          print(commentCount);
          return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.only(
                    top: width * 0.05,
                    left: width * 0.05,
                    right: width * 0.05,
                    bottom: width * 0.05),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    RichText(
                        text: TextSpan(
                            text: orders![index].name! + ' ,',
                            style: KTextStyle1,
                            children: const [
                          TextSpan(text: '  ' 'Name', style: KTextStyle2)
                        ])),
                    SizedBox(height: height * 0.02),
                    RichText(
                        text: TextSpan(
                            text: orders![index].food + ' ,',
                            style: KTextStyle1,
                            children: const [
                          TextSpan(text: '  ' 'Food', style: KTextStyle2)
                        ])),
                    SizedBox(height: height * 0.02),
                    RichText(
                        text: TextSpan(
                            text: orders![index].drink + ' ,',
                            style: KTextStyle1,
                            children: const [
                          TextSpan(text: '  ' 'Drink', style: KTextStyle2)
                        ])),
                    SizedBox(height: height * 0.03),
                    const Text(
                      'Comments',
                      style: KTextStyle2,
                    ),
                    Text(orders![index].comment!, style: KTextStyle4),
                  ],
                ),
              ));
        });
  }
}
