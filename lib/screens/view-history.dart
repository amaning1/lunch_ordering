import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lunch_ordering/providers/food_providers.dart';
import 'package:lunch_ordering/constants.dart';
import 'package:lunch_ordering/components.dart';
import 'package:provider/provider.dart';
import '../Domain/orders.dart';

class ViewHistory extends StatefulWidget {
  const ViewHistory({Key? key}) : super(key: key);

  @override
  State<ViewHistory> createState() => _ViewHistoryState();
}

class _ViewHistoryState extends State<ViewHistory> {
  var height, width;
  bool isLoading = false;
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
          padding: EdgeInsets.only(
              top: height * 0.04, left: height * 0.02, right: height * 0.04),
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
                      Text('BSL', style: KMENUTextStyle),
                      SizedBox(width: width * 0.02),
                      Text('ORDERS', style: KMENUTextStyle),
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
                  Text('ORDER HISTORY', style: KMENUTextStyle),
                ],
              ),
              SizedBox(height: height * 0.02),
              FutureBuilder<List<Orders>?>(
                  future: foodProvider.getPreviousOrders(context),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<Orders>? orders = snapshot.data;

                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: orders?.length,
                          itemBuilder: (BuildContext context, int index) {
                            var formatDate =
                                DateTime.tryParse(orders![index].time);
                            String Date =
                                DateFormat("yyyy-MM-dd").format(formatDate!);

                            return Card(
                                child: Padding(
                              padding: EdgeInsets.fromLTRB(height * 0.04,
                                  height * 0.02, height * 0.04, height * 0.02),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text('Date: ' + Date, style: KTextStyle3),
                                  SizedBox(height: height * 0.04),
                                  Text('Food: ' + orders[index].food,
                                      style: KTextStyle3),
                                  SizedBox(height: height * 0.04),
                                  Text('Drink: ' + orders[index].drink,
                                      style: KTextStyle3),
                                  SizedBox(height: height * 0.04),
                                  Text('Comment: ' + orders[index].comment!,
                                      style: KTextStyle3),
                                ],
                              ),
                            ));
                          });
                    } else if (snapshot.hasError) {
                      return Text("${snapshot.error}");
                    }
                    return Center(
                      child: CircularProgressIndicator(
                        color: blue,
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
