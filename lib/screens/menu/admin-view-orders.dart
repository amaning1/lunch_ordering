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
    bool isLoading = false;
    GlobalKey<FormState> formKey = GlobalKey<FormState>();
    var scaffoldKey = GlobalKey<ScaffoldState>();
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
              bslOrdersRow(width: width, scaffoldKey: scaffoldKey),
              FutureBuilder<List<Orders>?>(
                  future: foodProvider.getOrders(context),
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
                                  // Text('Name: ' + orders![index].name?,
                                  //     style: KCardTextStyle),
                                  SizedBox(height: height * 0.04),
                                  Text('Food: ' + orders![index].food,
                                      style: KCardTextStyle),
                                  SizedBox(height: height * 0.04),
                                  Text('Drink: ' + orders[index].drink,
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
