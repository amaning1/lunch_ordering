import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../components.dart';
import '../../constants.dart';
import '../../providers/registration_provider.dart';
import '../sign-in.dart';

class AdminAddUser extends StatefulWidget {
  const AdminAddUser({Key? key}) : super(key: key);

  @override
  State<AdminAddUser> createState() => _AdminAddUserState();
}

class _AdminAddUserState extends State<AdminAddUser> {
  bool isLoading = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();

  var height, width;
  String dropDownValue = 'user';

  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    bool isSelected = false;
    final regProvider = Provider.of<RegProvider>(context);
    return Scaffold(
        key: scaffoldKey,
        drawer: NavDrawer(),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(left: width * 0.05, right: width * 0.05),
            child: Form(
              key: regProvider.formKey1,
              child: Padding(
                padding: EdgeInsets.all(width * 0.02),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * 0.050),
                    bslOrdersRow(width: width, scaffoldKey: scaffoldKey),
                    SizedBox(height: height * 0.035),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 4,
                            blurRadius: 8,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(width * 0.05,
                            width * 0.035, width * 0.05, width * 0.035),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(height: height * 0.02),
                            Center(
                              child:
                                  Text('Add User Account', style: KNTSYAStyle),
                            ),
                            SizedBox(height: height * 0.05),
                            Text('Name', style: KButtonTextStyle),
                            SizedBox(height: height * 0.01),
                            form(
                              focusedBorder: true,
                              controller: regProvider.nameController,
                              label: 'Enter Name',
                              type: TextInputType.text,
                              colour: Color(0xFFF2F2F2),
                            ),
                            Text('Phone Number', style: KButtonTextStyle),
                            SizedBox(height: height * 0.01),
                            numberForm(
                              focusedBorder: true,
                              controller: regProvider.numberController,
                              label: 'Phone Number',
                              type: TextInputType.number,
                              colour: Color(0xFFF2F2F2),
                            ),
                            Text('Password', style: KButtonTextStyle),
                            SizedBox(height: height * 0.01),
                            passwordForm(
                              passwordcontroller:
                                  regProvider.passwordController,
                            ),
                            SizedBox(height: height * 0.01),
                            Text('User', style: KButtonTextStyle),
                            SizedBox(height: height * 0.01),
                            Container(
                              height: height * 0.07,
                              decoration:
                                  BoxDecoration(border: Border.all(width: 0.1)),
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  value: regProvider.dropDownValue,
                                  items: <String>['chef', 'admin', 'user']
                                      .map<DropdownMenuItem<String>>(
                                          (String value) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 8.0),
                                        child: Text(
                                          value,
                                          style: TextStyle(
                                            fontFamily: 'Poppins',
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                  onChanged: (String? newValue) {
                                    setState(() {
                                      regProvider.dropDownValue = newValue!;
                                    });
                                  },
                                ),
                              ),
                            ),
                            Center(
                              child: Container(
                                width: width,
                                height: height * 0.1,
                                child: Button(
                                  text: 'Add User',
                                  isLoading: regProvider.isLoadingRegister,
                                  onPressed: () async {
                                    regProvider.addUser(context);
                                  },
                                ),
                              ),
                            ),
                            SizedBox(height: height * 0.07),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
