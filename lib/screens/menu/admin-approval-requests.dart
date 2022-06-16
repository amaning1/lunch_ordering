import 'package:flutter/material.dart';
import 'package:lunch_ordering/providers/approval_provider.dart';
import 'package:provider/provider.dart';
import '../../Domain/new-user.dart';
import '../../components.dart';
import '../../constants.dart';

class AdminApprovalRequests extends StatefulWidget {
  const AdminApprovalRequests({Key? key}) : super(key: key);

  @override
  State<AdminApprovalRequests> createState() => _AdminApprovalRequestsState();
}

class _AdminApprovalRequestsState extends State<AdminApprovalRequests> {
  var height, width;
  bool isLoading = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    final approvalProvider = Provider.of<ApprovalProvider>(context);

    var approvalRequests = RefreshIndicator(
      onRefresh: () async {
        approvalProvider.getAllApprovalRequests(context);
        return Future<void>.delayed(const Duration(seconds: 3));
      },
      child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: approvalProvider.newUsers.length,
          itemBuilder: (BuildContext context, int index) {
            bool isLoading = false;
            return Card(
                child: Padding(
              padding: EdgeInsets.fromLTRB(
                  height * 0.04, height * 0.02, height * 0.04, height * 0.02),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: height * 0.02),
                  Text('Name: ' + approvalProvider.newUsers[index].name,
                      style: KTextStyle3),
                  SizedBox(height: height * 0.04),
                  Text(
                      'Phone: ' + approvalProvider.newUsers[index].phone_number,
                      style: KTextStyle3),
                  SizedBox(height: height * 0.04),
                  Text('Status: ' + approvalProvider.newUsers[index].status,
                      style: KTextStyle3),
                  SizedBox(height: height * 0.04),
                  Text('Type: ' + approvalProvider.newUsers[index].type,
                      style: KTextStyle3),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Button(
                        text: 'Approve',
                        isLoading: isLoading,
                        onPressed: () {
                          isLoading = true;
                          approvalProvider.approveUser(
                              approvalProvider.newUsers[index].user_id,
                              context);

                          setState(() {
                            isLoading = false;
                            approvalProvider.newUsers;
                          });
                        },
                        color: darkBlue,
                      ),
                      SizedBox(width: height * 0.01),
                      Button(
                        text: 'Deny',
                        isLoading: false,
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

    return Scaffold(
      key: scaffoldKey,
      drawer: const NavDrawer(),
      //resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.only(
            top: width * 0.05, left: width * 0.05, right: width * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: height * 0.050),
            bslOrdersRow(width: width, scaffoldKey: scaffoldKey),
            SizedBox(height: height * 0.035),
            Row(
              children: const [
                Text('APPROVALS', style: KMENUTextStyle),
              ],
            ),
            Expanded(
              child: approvalRequests,
            ),
          ],
        ),
      ),
    );
  }
}
