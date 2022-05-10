import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lunch_ordering/components.dart';
import 'package:lunch_ordering/constants.dart';

class AdminOrders extends StatefulWidget {
  const AdminOrders({Key? key}) : super(key: key);

  @override
  State<AdminOrders> createState() => _AdminOrdersState();
}

class _AdminOrdersState extends State<AdminOrders> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  var height, width;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController foodcontroller = TextEditingController();
  TextEditingController drinkcontroller = TextEditingController();

  void addFoodToList() {
    setState(() {
      food.add(foodcontroller.text);
    });
  }

  void addDrinkToList() {
    setState(() {
      drink.add(drinkcontroller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    bool isSelected = false;
    return Scaffold(
      key: scaffoldKey,
      drawer: Drawer(
        child: Padding(
          padding: const EdgeInsets.only(top: 60.0),
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                  leading: Icon(Icons.menu),
                  title: const Text('Menu',
                      style: TextStyle(fontFamily: 'Poppins')),
                  onTap: () {
                    Navigator.pushNamed(context, '/adminAdd');
                  }),
              ListTile(
                  leading: Icon(Icons.dashboard),
                  title: const Text('Dashboard',
                      style: TextStyle(fontFamily: 'Poppins')),
                  onTap: () {
                    Navigator.pushNamed(context, '/fourth');
                  }),
              ListTile(
                  leading: Icon(Icons.history),
                  title: const Text('History',
                      style: TextStyle(fontFamily: 'Poppins')),
                  onTap: () {}),
              ListTile(
                  leading: Icon(Icons.logout),
                  title: const Text('Logout',
                      style: TextStyle(fontFamily: 'Poppins')),
                  onTap: () {
                    logout();
                    Navigator.pushNamedAndRemoveUntil(
                        context, '/signin', (route) => false);
                  }),
            ],
          ),
        ),
      ),
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
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: food.length,
                        itemBuilder: (BuildContext context, int index) {
                          return ChefCards(
                              height: height,
                              width: width,
                              number: '12',
                              text: food[index],
                              icon: null);
                        }),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
