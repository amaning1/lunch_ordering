import 'package:flutter/material.dart';
import 'package:lunch_ordering/providers/approval_provider.dart';
import 'package:provider/provider.dart';

import '../../Domain/allUsers.dart';
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
    final approvalProvider = Provider.of<ApprovalProvider>(context);

    return Scaffold(
      key: scaffoldKey,
      drawer: NavDrawer(),
      //resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.only(
              top: width * 0.05, left: width * 0.05, right: width * 0.05),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: height * 0.050),
              bslOrdersRow(width: width, scaffoldKey: scaffoldKey),
              SizedBox(height: height * 0.035),
              SizedBox(height: height * 0.05),
              Row(
                children: [
                  Text('APPROVALS', style: KMENUTextStyle),
                ],
              ),
              SizedBox(height: height * 0.02),
              FutureBuilder<List<NewUser>?>(
                  future: approvalProvider.getAllApprovalRequests(context),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      List<NewUser>? users = snapshot.data;
                      return RefreshIndicator(
                        onRefresh: () async {
                          approvalProvider.getAllApprovalRequests(context);
                        },
                        child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: users?.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                  child: Padding(
                                padding: EdgeInsets.fromLTRB(
                                    height * 0.04,
                                    height * 0.02,
                                    height * 0.04,
                                    height * 0.02),
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
                                          isLoading: approvalProvider.isLoading,
                                          onPressed: () {
                                            approvalProvider.approveUser(
                                                users[index].user_id);
                                          },
                                          color: darkBlue,
                                        ),
                                        SizedBox(width: height * 0.01),
                                        Button(
                                          text: 'Deny',
                                          isLoading: approvalProvider.isLoading,
                                          onPressed: () {},
                                          color: Colors.red,
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ));
                            }),
                      );
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
