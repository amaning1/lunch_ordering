import 'package:flutter/material.dart';

Color blue = Color(0xFF007AFF);
Color darkblue = Color(0xFF002C59);
Color grayish = Color(0xFFE4EBF2);

bool state = false;
late String email = '';
late String password = '';
String phone_number = '';
bool SwitchSelected = false;
bool isObscure = true;

final TextEditingController passwordcontroller = TextEditingController();
final TextEditingController numbercontroller = TextEditingController();

const KButtonTextStyle = TextStyle(
    color: Color(0xFF002C59),
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    fontSize: 16);

const KNTSYAStyle = TextStyle(
    color: Color(0xFF002C59),
    fontFamily: 'Poppins',
    fontWeight: FontWeight.w600,
    fontSize: 24);
