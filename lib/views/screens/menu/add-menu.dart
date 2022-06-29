import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lunch_ordering/components.dart';
import 'package:lunch_ordering/constants.dart';
import 'package:lunch_ordering/Domain/ChipData.dart';
import 'package:lunch_ordering/providers/approval_provider.dart';
import 'package:lunch_ordering/providers/menu_provider.dart';
import 'package:provider/provider.dart';
import '../../providers/auth_provider.dart';
import '../../providers/food_providers.dart';

int? selected = 0;

class AddMenu extends StatefulWidget {
  const AddMenu({Key? key}) : super(key: key);

  @override
  State<AddMenu> createState() => _AddMenuState();
}

class _AddMenuState extends State<AddMenu> {
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  var height, width;
  final List<ChipData> allChips = [];
  int selectedIndex = 0;

  int index = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    final menuProvider = Provider.of<MenuProvider>(context);
    final foodProvider = Provider.of<FoodProvider>(context);
    final authProvider = Provider.of<AuthProvider>(context);
    final approvalProvider = Provider.of<ApprovalProvider>(context);

    var dropDownValue = approvalProvider.chefNames.first;
    return Scaffold(
      key: scaffoldKey,
      drawer: const NavDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              top: width * 0.05, left: width * 0.05, right: width * 0.05),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              SizedBox(height: height * 0.030),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset('images/img.png', height: 40, width: 45),
                      SizedBox(width: width * 0.03),
                      const Text('ADD', style: KMENUTextStyle),
                      SizedBox(width: width * 0.02),
                      const Text('MENU', style: KCardTextStyle),
                    ],
                  ),
                  IconButton(
                    icon: const Icon(Icons.menu),
                    onPressed: () => scaffoldKey.currentState?.openDrawer(),
                  ),
                ],
              ),
              SizedBox(height: height * 0.030),
              Container(
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
                  padding: EdgeInsets.all(height * 0.05),
                  child: Column(
                    children: [
                      SizedBox(
                        width: width,
                        child: Button(
                          text: "${selectedDate.toLocal()}".split(' ')[0],
                          isLoading: false,
                          onPressed: () {
                            selectDate(context);
                          },
                        ),
                      ),
                      authProvider.user.type == 'admin'
                          ? Container(
                              height: height * 0.07,
                              decoration:
                                  BoxDecoration(border: Border.all(width: 0.1)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: dropDownValue,
                                  items: approvalProvider.chefNames
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          value,
                                          style: const TextStyle(
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      dropDownValue = newValue!;
                                    });
                                  },
                                ),
                              ),
                            )
                          : const SizedBox(),
                      row('Food', foodProvider.isLoading, () {
                        foodProvider.typeFood();
                        Navigator.pushNamed(context, '/adminAdd');
                      }),
                      Padding(
                        padding: const EdgeInsets.only(top: 10, bottom: 10),
                        child: GestureDetector(
                          onTap: () {
                            foodProvider.typeFood();
                            Navigator.pushNamed(context, '/adminAdd');
                          },
                          child: column(foodProvider.foodChips.isEmpty, context,
                              'Food', foodProvider.foodChips, () {
                            foodProvider.typeFood();
                            Navigator.pushNamed(context, '/adminAdd');
                          }, foodProvider.isLoading),
                        ),
                      ),
                      SizedBox(height: height * 0.03),
                      row('Drink', foodProvider.isLoading, () {
                        foodProvider.typeDrink();
                        Navigator.pushNamed(context, '/adminAdd');
                      }),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
                        child: GestureDetector(
                          onTap: () {
                            foodProvider.typeDrink();
                            Navigator.pushNamed(context, '/adminAdd');
                          },
                          child: column(foodProvider.drinkChips.isEmpty,
                              context, 'Drink', foodProvider.drinkChips, () {
                            foodProvider.typeDrink();
                            Navigator.pushNamed(context, '/adminAdd');
                          }, foodProvider.isLoading),
                        ),
                      ),
                      foodProvider.drinkChips.isEmpty
                          ? SizedBox(height: height * 0.02)
                          : const SizedBox(),
                      SizedBox(
                        width: width,
                        child: Button(
                          text: 'Add to Menu',
                          isLoading: menuProvider.isLoading,
                          onPressed: () {
                            authProvider.user.type == 'admin'
                                ? menuProvider.addMenuAdmin(
                                    dropDownValue,
                                    foodProvider.foodIDS,
                                    foodProvider.drinkIDS,
                                    context)
                                : menuProvider.addMenu(foodProvider.foodIDS,
                                    foodProvider.drinkIDS, context);
                          },
                        ),
                      ),
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

  void selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate.add(const Duration(days: 1)),
      firstDate: DateTime(2022),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: darkBlue,
              onPrimary: Colors.white,
              onSurface: darkBlue,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: darkBlue, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }
}
