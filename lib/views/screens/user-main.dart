import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lunch_ordering/components.dart';
import 'package:lunch_ordering/constants.dart';
import 'package:lunch_ordering/views/screens/main-screen.dart';
import 'package:lunch_ordering/views/screens/view-history.dart';
import '/controllers/providers/auth_provider.dart';
import 'package:provider/provider.dart';

class UserMain extends StatefulWidget {
  const UserMain({Key? key}) : super(key: key);

  @override
  State<UserMain> createState() => _UserMainState();
}

class _UserMainState extends State<UserMain> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    final authProvider = Provider.of<AuthProvider>(context);

    return Scaffold(
      drawer: MainScreenDrawer(),
      body: WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.only(
                left: width * 0.05, right: width * 0.05, top: width * 0.1),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                    Widget>[
              Row(
                children: [
                  Image.asset('images/img.png', height: 40, width: 45),
                  SizedBox(width: width * 0.03),
                  const Text(
                    'BSL',
                    style: KMENUTextStyle,
                  ),
                  SizedBox(width: width * 0.02),
                  const Text('ORDERS', style: KCardTextStyle),
                ],
              ),
              SizedBox(height: height * 0.06),
              Text(
                'Welcome ${authProvider.user.name},',
                style: KMENUTextStyle,
              ),
              SizedBox(height: height * 0.14),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  maintainState: false,
                                  builder: (context) => const MenuScreen()));
                        },
                        child: Container(
                          height: height * 0.35,
                          width: height * 0.24,
                          decoration: BoxDecoration(
                            color: grayish,
                            borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20)),
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          maintainState: false,
                                          builder: (context) =>
                                              const MenuScreen()));
                                },
                                icon: const Icon(Icons.fastfood),
                                iconSize: height * 0.15,
                              ),
                              const Text(
                                'Order Food',
                                style: KButtonTextStyle,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: width * 0.04),
                    Expanded(
                      child: GestureDetector(
                        onTap: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ViewHistory()));
                        },
                        child: Container(
                          height: height * 0.35,
                          width: height * 0.24,
                          decoration: BoxDecoration(
                            color: grayish,
                            borderRadius: KBorderRadius,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              IconButton(
                                onPressed: () {
                                  Navigator.pushNamed(context, '/history');
                                },
                                icon: const Icon(Icons.history),
                                iconSize: height * 0.15,
                              ),
                              const Text(
                                'History',
                                style: KButtonTextStyle,
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ]),
              SizedBox(height: height * 0.10),
            ]),
          ),
        ),
      ),
    );
  }
}
