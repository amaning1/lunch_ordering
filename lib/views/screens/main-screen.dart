import 'package:flutter/material.dart';
import 'package:lunch_ordering/components.dart';
import 'package:lunch_ordering/constants.dart';
import '/controllers/providers/auth_provider.dart';
import '/controllers/providers/food_providers.dart';
import 'package:provider/provider.dart';

int? foodSelected;
int? drinkSelected;

class MenuScreen extends StatefulWidget {
  const MenuScreen({Key? key}) : super(key: key);

  @override
  State<MenuScreen> createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {
  static final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(debugLabel: 'main');
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  TextEditingController comments = TextEditingController();

  @override
  void initState() {
    comments.text = '';

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final foodProvider = Provider.of<FoodProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);

    Widget foodMenu(BuildContext context) {
      return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: foodProvider.menu.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                title: Text(foodProvider.menu[index].food_name!),
                selected: index == foodProvider.selectedFoodIndex,
                onTap: () {
                  setState(() {
                    foodProvider.selectedFoodIndex = index;
                    foodSelected = foodProvider.menu[index].food_id!;
                  });
                },
                selectedTileColor: darkBlue,
                selectedColor: Colors.white,
              ),
            );
          });
    }

    Widget drinksMenu(BuildContext context) {
      return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: foodProvider.drinks.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                title: Text(foodProvider.drinks[index].drinkName),
                selected: index == foodProvider.selectedDrinkIndex,
                onTap: () {
                  setState(() {
                    foodProvider.selectedDrinkIndex = index;
                    drinkSelected = foodProvider.drinks[index].drinkId;
                  });
                },
                selectedTileColor: darkBlue,
                selectedColor: Colors.white,
              ),
            );
          });
    }

    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        drawer: authProvider.user.type == 'user'
            ? MainScreenDrawer()
            : const NavDrawer(),
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.only(
                  left: width * 0.05, right: width * 0.05, top: width * 0.1),
              child: Stack(children: <Widget>[
                bslOrdersRow(width: width, scaffoldKey: scaffoldKey),
                SizedBox(height: height * 0.10),
                foodProvider.isMenu
                    ? Padding(
                        padding: EdgeInsets.only(top: width * 0.20),
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: KBorderRadius,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                spreadRadius: 4,
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: width * 0.05,
                                right: width * 0.05,
                                bottom: width * 0.05),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  SizedBox(height: height * 0.08),
                                  Center(
                                    child: Text('Bon Appétit',
                                        style: TextStyle(
                                            fontFamily: 'Poppins',
                                            color: darkBlue,
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20)),
                                  ),
                                  SizedBox(height: height * 0.02),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      const Text('Choose Food',
                                          style: KButtonTextStyle),
                                      foodMenu(context),
                                      SizedBox(height: height * 0.04),
                                    foodProvider.drinks.isNotEmpty?  const Text('Choose Drink',
                                          style: KButtonTextStyle): const SizedBox(),
                                      drinksMenu(context),
                                      SizedBox(height: height * 0.04),
                                      const Text('Comments',
                                          style: KButtonTextStyle),
                                      SizedBox(height: height * 0.04),
                                      Container(
                                          decoration: BoxDecoration(
                                            color: darkBlue,
                                            borderRadius: const BorderRadius.all(
                                                Radius.circular(10)),
                                          ),
                                          height: width * 0.3,
                                          child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: TextInput(
                                                controller: foodProvider.comments,
                                              ))),
                                      SizedBox(height: height * 0.02),
                                      foodProvider.selectedFoodIndex == null
                                          ? const SizedBox()
                                          : Center(
                                              child: SizedBox(
                                                width: width * 0.5,
                                                height: height * 0.1,
                                                child: Button(
                                                  onPressed: () async {
                                                    foodProvider.updateOrder
                                                        ? foodProvider
                                                            .updateFoodOrder(
                                                                context)
                                                        : foodProvider
                                                            .orderFood(context);
                                                  },
                                                  isLoading:
                                                      foodProvider.isLoading,
                                                  text: foodProvider.updateOrder
                                                      ? 'Update Order'
                                                      : 'Order Food',
                                                ),
                                              ),
                                            ),
                                    ],
                                  ),
                                  SizedBox(height: height * 0.02),
                                ]),
                          ),
                        ),
                      )
                    : Padding(
                        padding: EdgeInsets.only(top: height * 0.30),
                        child: Container(
                          height: height * 0.25,
                          width: height * 0.6,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: KBorderRadius,
                          ),
                          child: const Center(
                              child: Text('No Menu for Today',
                                  style: KCardTextStyle)),
                        ),
                      ),
                foodProvider.isMenu
                    ? Positioned(
                        left: width * 0.33,
                        top: width * 0.13,
                        child: Image.asset('images/img_1.png',
                            height: width * 0.175, width: width * 0.25),
                      )
                    : const SizedBox(),
              ]),
            ),
          ),
        ),
      ),
    );
  }
}
