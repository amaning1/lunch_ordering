import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../Domain/new-user.dart';
import '../../Domain/user.dart';
import '../../components.dart';
import '../../constants.dart';
import '../../providers/food_providers.dart';

class AdminApprovalRequests extends StatefulWidget {
  const AdminApprovalRequests({Key? key}) : super(key: key);

  @override
  State<AdminApprovalRequests> createState() => _AdminApprovalRequestsState();
}

class _AdminApprovalRequestsState extends State<AdminApprovalRequests> {
  var height, width;
  bool isLoading = false;
  var scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    bool isSelected = false;
    final foodProvider = Provider.of<FoodProvider>(context);

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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset('images/img.png', height: 40, width: 45),
                      SizedBox(width: width * 0.03),
                      Text('BSL', style: KMENUTextStyle),
                      SizedBox(width: width * 0.02),
                      Text('ORDERS', style: KCardTextStyle),
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
                  Text('APPROVALS', style: KMENUTextStyle),
                ],
              ),
              SizedBox(height: height * 0.02),
              FutureBuilder<List<NewUser>?>(
                  future: foodProvider.getAllApprovalRequests(context),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<NewUser>? users = snapshot.data;
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: users?.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                                child: Padding(
                              padding: EdgeInsets.fromLTRB(height * 0.04,
                                  height * 0.02, height * 0.04, height * 0.02),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  SizedBox(height: height * 0.02),
                                  Text('Name: ' + users![index].name,
                                      style: KTextStyle3),
                                  SizedBox(height: height * 0.04),
                                  Text('Phone: ' + users[index].phone_number,
                                      style: KTextStyle3),
                                  SizedBox(height: height * 0.04),
                                  Text('Status: ' + users[index].status,
                                      style: KTextStyle3),
                                  SizedBox(height: height * 0.04),
                                  Text('Type: ' + users[index].type,
                                      style: KTextStyle3),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Button(
                                        text: 'Approve',
                                        isLoading: foodProvider.menuLoading,
                                        onPressed: () {
                                          foodProvider.approveUser(
                                              users[index].user_id);
                                        },
                                      ),
                                      SizedBox(width: height * 0.01),
                                      Button(
                                        text: 'Deny',
                                        isLoading: foodProvider.menuLoading,
                                        onPressed: () {},
                                      ),
                                    ],
                                  )
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
