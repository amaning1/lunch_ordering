import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lunch_ordering/components.dart';
import 'package:lunch_ordering/constants.dart';
import 'package:lunch_ordering/controllers/providers/food_providers.dart';
import 'package:provider/provider.dart';

class AdminOrders extends StatefulWidget {
  const AdminOrders({Key? key}) : super(key: key);

  @override
  State<AdminOrders> createState() => _AdminOrdersState();
}

class _AdminOrdersState extends State<AdminOrders> {
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var height, width;
  int selectedIndex = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    TextEditingController food = TextEditingController();
    final foodProvider = Provider.of<FoodProvider>(context);

    var allFoods = RefreshIndicator(
      onRefresh: () async {
        foodProvider.fetchAllFoods(context);
        return Future<void>.delayed(const Duration(seconds: 3));
      },
      child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          //shrinkWrap: true,
          itemCount: foodProvider.allFoods.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                title: Text(foodProvider.allFoods[index].Option!),
                subtitle: Text(foodProvider.allFoods[index].id!.toString()),
                trailing: IconButton(
                  onPressed: () {
                    foodProvider.deleteFood(foodProvider.allFoods[index].id!);
                    setState(() {
                      foodProvider.allFoods;
                    });
                  },
                  icon: const Icon(Icons.delete),
                ),
              ),
            );
          }),
    );
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        drawer: const NavDrawer(),
        body: Padding(
          padding: EdgeInsets.only(
              top: height * 0.03, left: width * 0.05, right: width * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              bslOrdersRow(width: width, scaffoldKey: scaffoldKey),
              Expanded(
                child: allFoods,
              ),
            ],
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                    shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(5.0))),
                    title: const Text('Add Food', style: KAlertHeader),
                    //insetPadding: EdgeInsets.symmetric(vertical: 240),
                    content: TextFormField(
                      controller: food,
                    ),
                    actions: [
                      TextButton(
                        child: const Text(
                          'Add',
                          style: KAlertButton,
                        ),
                        onPressed: () {
                          foodProvider.newFood.add(food.text);
                          foodProvider.addNewFood(foodProvider.newFood, context);
                        },
                      ),
                    ]);
              },
            );
          },
          backgroundColor: darkBlue,
          label: const Text('Add Food'),
          icon: const Icon(Icons.add),
        ),
      ),
    );
  }
}
