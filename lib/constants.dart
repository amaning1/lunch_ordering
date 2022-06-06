import 'package:flutter/material.dart';

Color blue = const Color(0xFF007AFF);
Color darkBlue = const Color(0xFF002C59);
Color grayish = const Color(0xFFE4EBF2);

bool state = false;
bool switchSelected = false;
bool isObscure = true;
DateTime selectedDate = DateTime.now();

const KButtonTextStyle = TextStyle(
    color: Color(0xFF002C59),
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    fontSize: 16);
const KCardTextStyle = TextStyle(
    color: Color(0xFF002C59),
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    fontSize: 20);

const KNTSYAStyle = TextStyle(
    color: Color(0xFF002C59),
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    fontSize: 24);

const KForgotPassword = TextStyle(
    color: Color(0xFF007AFF),
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w400,
    fontSize: 15);

const KMENUTextStyle =
    TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600, fontSize: 20);

const KTextStyle3 =
    TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w400, fontSize: 15);

const KAlertHeader = TextStyle(
    color: Colors.black87,
    fontFamily: 'Poppins',
    fontWeight: FontWeight.bold,
    fontSize: 16);

const menuLarge = TextStyle(
    color: Color(0xFF002C59),
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    fontSize: 16);

const KAlertContent = TextStyle(
  fontFamily: 'Poppins',
);

const KAlertButton =
    TextStyle(fontWeight: FontWeight.bold, fontFamily: 'Poppins');

class bslOrdersRow extends StatelessWidget {
  const bslOrdersRow({
    Key? key,
    required this.width,
    required this.scaffoldKey,
  }) : super(key: key);

  final width;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
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
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
      ],
    );
  }
}

class bslMenu extends StatelessWidget {
  const bslMenu({
    Key? key,
    required this.width,
    required this.scaffoldKey,
  }) : super(key: key);

  final width;
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Image.asset('images/img.png', height: 40, width: 45),
            SizedBox(width: width * 0.03),
            Text('MENU', style: KCardTextStyle),
            SizedBox(width: width * 0.02),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () => scaffoldKey.currentState?.openDrawer(),
        ),
      ],
    );
  }
}
