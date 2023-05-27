import 'package:flutter/material.dart';

import 'app_color.dart';

ThemeData darkTheme = ThemeData(
    appBarTheme: AppBarTheme(color: Colors.teal[900]),
    brightness: Brightness.dark,
    backgroundColor: AppColor.buttonBackgroundColorDark,
    scaffoldBackgroundColor: AppColor.bodyColorDark,
    hintColor: AppColor.textColor,
    primaryColorLight: AppColor.buttonBackgroundColorDark,
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(primary: Color(0xff0F3D3E))),
    textTheme: const TextTheme(
        headline1: TextStyle(
            color: Colors.grey, fontSize: 35, fontWeight: FontWeight.bold)),
    buttonTheme: const ButtonThemeData(
        textTheme: ButtonTextTheme.primary, buttonColor: Colors.teal),
    primarySwatch: Colors.teal,
    cardTheme: CardTheme(color: Colors.teal[800]),
    iconTheme: IconThemeData(color: Colors.grey[300], size: 18),
    fontFamily: 'Oswald');
