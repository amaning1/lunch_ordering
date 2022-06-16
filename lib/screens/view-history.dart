import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lunch_ordering/providers/food_providers.dart';
import 'package:lunch_ordering/constants.dart';
import 'package:lunch_ordering/components.dart';
import 'package:provider/provider.dart';

class ViewHistory extends StatefulWidget {
  const ViewHistory({Key? key}) : super(key: key);

  @override
  State<ViewHistory> createState() => _ViewHistoryState();
}

class _ViewHistoryState extends State<ViewHistory> {
  var height, width;
  bool isLoading = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    final foodProvider = Provider.of<FoodProvider>(context);

    return Scaffold(
      key: scaffoldKey,
      drawer: MainScreenDrawer(),
      //resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.only(
            left: width * 0.05, right: width * 0.05, top: width * 0.1),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            bslOrdersRow(width: width, scaffoldKey: scaffoldKey),
            SizedBox(height: height * 0.035),
            Row(
              children: const [
                Text('ORDER HISTORY', style: KMENUTextStyle),
              ],
            ),
            SizedBox(height: height * 0.02),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  foodProvider.getPreviousOrders(context);
                  return Future<void>.delayed(const Duration(seconds: 3));
                },
                child: ListView.builder(
                    physics: const AlwaysScrollableScrollPhysics(),
                    shrinkWrap: true,
                    reverse: true,
                    itemCount: foodProvider.list.length,
                    itemBuilder: (BuildContext context, int index) {
                      var formatDate =
                          DateTime.tryParse(foodProvider.list[index].time!);
                      String date =
                          DateFormat("yyyy-MM-dd").format(formatDate!);

                      return Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(height * 0.04,
                                height * 0.02, height * 0.04, height * 0.02),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(height: height * 0.03),
                                RichText(
                                    text: TextSpan(
                                        text: foodProvider.list[index].food +
                                            ' ,',
                                        style: KTextStyle1,
                                        children: const [
                                      TextSpan(
                                          text: '  ' 'Food', style: KTextStyle2)
                                    ])),
                                SizedBox(height: height * 0.02),
                                RichText(
                                    text: TextSpan(
                                        text: foodProvider.list[index].drink +
                                            ' ,',
                                        style: KTextStyle1,
                                        children: const [
                                      TextSpan(
                                          text: '  ' 'Drink',
                                          style: KTextStyle2)
                                    ])),
                                SizedBox(height: height * 0.03),
                                const Text(
                                  'Comments',
                                  style: KTextStyle2,
                                ),
                                Text(foodProvider.list[index].comment!,
                                    style: KTextStyle4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text('Date: ' + date, style: KTextStyle3),
                                  ],
                                ),
                              ],
                            ),
                          ));
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
