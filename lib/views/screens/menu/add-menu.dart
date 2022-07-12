import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lunch_ordering/components.dart';
import 'package:lunch_ordering/constants.dart';
import 'package:lunch_ordering/models/ChipData.dart';
import 'package:lunch_ordering/controllers/providers/approval_provider.dart';
import 'package:lunch_ordering/controllers/providers/menu_provider.dart';
import 'package:provider/provider.dart';
import '/controllers/providers/auth_provider.dart';
import '/controllers/providers/food_providers.dart';

int? chefSelected = 0;

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

    String? dropDownValue;

    Widget allChefs(BuildContext context) {
      return ListView.builder(
          physics: const NeverScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: approvalProvider.allChefs!.length,
          itemBuilder: (BuildContext context, int index) {
            return Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                title: Text(approvalProvider.allChefs![index].name),
                selected: index == menuProvider.selectedIndex,
                onTap: () {
                  setState(() {
                    menuProvider.selectedIndex = index;
                    chefSelected = approvalProvider.allChefs![index].id;
                  });
                },
                selectedTileColor: darkBlue,
                selectedColor: Colors.white,
              ),
            );
          });
    }

    int? ddV;
    return SafeArea(
      child: Scaffold(
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
                            ?allChefs(context)
                        //     Expanded(
                        //   child: ListView.builder(
                        //       scrollDirection: Axis.vertical,
                        //       shrinkWrap: true,
                        //       itemCount: approvalProvider.allChefs!.length,
                        //       itemBuilder: (BuildContext context, int index) {
                        //         return Card(
                        //           shape: RoundedRectangleBorder(
                        //             borderRadius: BorderRadius.circular(10.0),
                        //           ),
                        //           child: ListTile(
                        //             shape: RoundedRectangleBorder(
                        //               borderRadius: BorderRadius.circular(10.0),
                        //             ),
                        //             title: Text(approvalProvider.allChefs![index].name),
                        //             selected: menuProvider.chefIDS
                        //                 .contains(approvalProvider.allChefs![index].id),
                        //             onTap: () {
                        //               setState(() {
                        //                 menuProvider.chefIDS.contains(
                        //                     approvalProvider.allChefs![index].id)
                        //                     ? menuProvider.removeChef(
                        //                     foodProvider.allFoods[index].id)
                        //                     : menuProvider.addChef(
                        //                     foodProvider.allFoods,
                        //                     index,
                        //                     selectedIndex);
                        //                 //selected = menu[index].id!;
                        //               });
                        //             },
                        //             selectedTileColor: darkBlue,
                        //             selectedColor: Colors.white,
                        //           ),
                        //         );
                        //       }),
                        // )
                        // Container(
                        //         height: height * 0.07,
                        //         decoration:
                        //             BoxDecoration(border: Border.all(width: 0.1)),
                        //         child: DropdownButtonHideUnderline(
                        //           child: DropdownButtonFormField(
                        //             value: dropDownValue,
                        //             hint: const Text('Select Chef'),
                        //             isExpanded: true,
                        //             items: approvalProvider.allChefs!
                        //                 .map((allChefs) {
                        //               return DropdownMenuItem(
                        //                 value: allChefs.id,
                        //                 child: Padding(
                        //                   padding:
                        //                   const EdgeInsets.only(left: 8.0),
                        //                   child: Text(
                        //                     allChefs.name,
                        //                     style: const TextStyle(
                        //                       fontFamily: 'Poppins',
                        //                     ),
                        //                   ),
                        //                 ),
                        //               );
                        //             }).toList(),
                        //             onSaved: ( value) {
                        //               setState(() {
                        //                 dropDownValue = value as String?;
                        //
                        //
                        //               });
                        //             },
                        //             onChanged: (value) {
                        //               setState(() {
                        //                 dropDownValue = value! as String?;
                        //               });
                        //             },
                        //           ),
                        //         ),
                        //       )
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
                                      chefSelected,
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
