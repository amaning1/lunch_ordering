import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:lunch_ordering/controllers/providers/approval_provider.dart';
import 'package:provider/provider.dart';
import '../../../components.dart';
import '../../../constants.dart';

class EveryUser extends StatefulWidget {
  const EveryUser({Key? key}) : super(key: key);

  @override
  State<EveryUser> createState() => _EveryUserState();
}

class _EveryUserState extends State<EveryUser> {
  var height, width;
  bool isLoading = false;
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    final approvalProvider = Provider.of<ApprovalProvider>(context);

    var allUsers = RefreshIndicator(
      onRefresh: () async {
        await approvalProvider.getAllUsers(context);

        return Future<void>.delayed(const Duration(seconds: 5));
      },
      child: ListView.builder(
          physics: const AlwaysScrollableScrollPhysics(),
          shrinkWrap: true,
          itemCount: approvalProvider.allUsers.length,
          itemBuilder: (BuildContext context, int index) {
            var formatDate =
                DateTime.tryParse(approvalProvider.allUsers[index].created_at);
            String date = DateFormat("yyyy-MM-dd").format(formatDate!);

            return Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(height * 0.04, height * 0.02,
                      height * 0.04, height * 0.02),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RichText(
                          text: TextSpan(
                        text: approvalProvider.allUsers[index].name,
                        style: KTextStyle1,
                      )),
                      SizedBox(height: height * 0.02),

                      RichText(
                          text: TextSpan(
                              text: approvalProvider.allUsers[index].id
                                      .toString() +
                                  ' ,',
                              style: KTextStyle1,
                              children: const [
                            TextSpan(text: '  ' 'Id', style: KTextStyle2)
                          ])),
                      //SizedBox(height: height * 0.02),

                      RichText(
                          text: TextSpan(
                              text: approvalProvider
                                      .allUsers[index].phone_number +
                                  ' ,',
                              style: KTextStyle1,
                              children: const [
                            TextSpan(
                                text: '  ' 'Phone Number', style: KTextStyle2)
                          ])),
                      //SizedBox(height: height * 0.02),
                      RichText(
                          text: TextSpan(
                              text:
                                  approvalProvider.allUsers[index].type + ' ,',
                              style: KTextStyle1,
                              children: const [
                            TextSpan(text: '  ' 'Type', style: KTextStyle2)
                          ])),
                      // SizedBox(height: height * 0.02),
                      RichText(
                          text: TextSpan(
                              text: approvalProvider.allUsers[index].status +
                                  ' ,',
                              style: KTextStyle1,
                              children: const [
                            TextSpan(text: '  ' 'Status', style: KTextStyle2)
                          ])),
                      RichText(
                          text: TextSpan(
                              text: date + ' ,',
                              style: KTextStyle1,
                              children: const [
                            TextSpan(
                                text: '  ' 'Date Added', style: KTextStyle2)
                          ])),
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
            top: height * 0.05,
            left: width * 0.05,
            right: width * 0.05,
            bottom: height * 0.05),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            bslOrdersRow(width: width, scaffoldKey: scaffoldKey),
            SizedBox(height: height * 0.035),
            Row(
              children: const [
                Text('ALL USERS', style: KMENUTextStyle),
              ],
            ),
            SizedBox(height: height * 0.02),
            Expanded(
              child: allUsers,
            ),
          ],
        ),
      ),
    );
  }
}
