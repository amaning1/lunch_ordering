import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lunch_ordering/providers/approval_provider.dart';
import 'package:provider/provider.dart';

import '../../Domain/allUsers.dart';
import '../../Domain/new-user.dart';
import '../../Domain/user.dart';
import '../../components.dart';
import '../../constants.dart';
import '../../providers/food_providers.dart';

class EveryUser extends StatefulWidget {
  const EveryUser({Key? key}) : super(key: key);

  @override
  State<EveryUser> createState() => _EveryUserState();
}

class _EveryUserState extends State<EveryUser> {
  var height, width;
  bool isLoading = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    final approvalProvider = Provider.of<ApprovalProvider>(context);

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
              SizedBox(height: height * 0.05),
              Row(
                children: [
                  Text('ALL USERS', style: KMENUTextStyle),
                ],
              ),
              SizedBox(height: height * 0.02),
              FutureBuilder<List<AllUsers>?>(
                  future: approvalProvider.getAllUsers(context),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<AllUsers>? users = snapshot.data;
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: users?.length,
                          itemBuilder: (BuildContext context, int index) {
                            var formatDate =
                                DateTime.tryParse(users![index].created_at);
                            String Date =
                                DateFormat("yyyy-MM-dd").format(formatDate!);

                            return Card(
                                child: Padding(
                              padding: EdgeInsets.fromLTRB(height * 0.04,
                                  height * 0.02, height * 0.04, height * 0.02),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: height * 0.02),
                                  Text('Id: ' + users[index].id.toString(),
                                      style: KTextStyle3),
                                  SizedBox(height: height * 0.04),
                                  Text('Name: ' + users[index].name,
                                      style: KTextStyle3),
                                  SizedBox(height: height * 0.04),
                                  Text(
                                      'Phone Number: ' +
                                          users[index].phone_number,
                                      style: KTextStyle3),
                                  SizedBox(height: height * 0.04),
                                  Text('Type: ' + users[index].type,
                                      style: KTextStyle3),
                                  SizedBox(height: height * 0.04),
                                  Text('Status: ' + users[index].status,
                                      style: KTextStyle3),
                                  Text('Date: ' + Date, style: KTextStyle3),
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
