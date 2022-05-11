import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lunch_ordering/components.dart';
import 'package:lunch_ordering/constants.dart';

class AdminAdd extends StatefulWidget {
  const AdminAdd({Key? key}) : super(key: key);

  @override
  State<AdminAdd> createState() => _AdminAddState();
}

class _AdminAddState extends State<AdminAdd> {
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
      drawer: NavDrawer(),
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
              Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  color: Colors.white,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Add Food',
                            style: TextStyle(
                                color: darkblue,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 16)),
                        TextFormField(
                          controller: foodcontroller,
                        ),
                        Container(
                          width: width * 0.4,
                          child: Button(
                            text: 'Add to Menu',
                            isLoading: false,
                            onPressed: () {
                              addFoodToList();
                            },
                          ),
                        ),
                        SizedBox(height: height * 0.03),
                        Text('Add Drink',
                            style: TextStyle(
                                color: darkblue,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w600,
                                fontSize: 16)),
                        TextFormField(
                          controller: drinkcontroller,
                        ),
                        Container(
                          width: width * 0.4,
                          child: Button(
                            text: 'Add to Menu',
                            isLoading: false,
                            onPressed: () {
                              addDrinkToList();
                            },
                          ),
                        )
                      ],
                    ),
                  )),
              SizedBox(height: height * 0.05),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                color: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Center(
                          child: Text('Menu',
                              style: TextStyle(
                                  color: Color(0xFF002C59),
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  fontSize: 24))),
                      Text('Food', style: KButtonTextStyle),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: food.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                  title: Text('${food[index]}'),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      food.removeAt(index);
                                    },
                                  ),
                                  tileColor: grayish),
                            );
                          }),
                      Text('Drink', style: KButtonTextStyle),
                      ListView.builder(
                          shrinkWrap: true,
                          itemCount: drink.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ListTile(
                                  title: Text('${drink[index]}'),
                                  trailing: IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () {
                                      drink.removeAt(index);
                                    },
                                  ),
                                  tileColor: grayish),
                            );
                          }),
                      Center(
                        child: Button(
                          text: 'Submit Menu',
                          isLoading: false,
                          onPressed: () {},
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
