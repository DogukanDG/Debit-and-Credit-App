import 'package:flutter/material.dart';

import 'app_color.dart';

ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,
    backgroundColor: AppColor.bodyColor,
    scaffoldBackgroundColor: AppColor.bodyColor,
    primaryColor: AppColor.buttonBackgroundColor,
    iconTheme: IconThemeData(color: Colors.white, size: 18),
    textTheme: TextTheme(
      bodyText2: TextStyle(color: Colors.white),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(primary: Colors.teal)),
    buttonTheme: const ButtonThemeData(
        textTheme: ButtonTextTheme.primary, buttonColor: Colors.white),
    colorScheme: ColorScheme.fromSwatch().copyWith(secondary: Colors.brown),
    appBarTheme: (AppBarTheme(color: Colors.teal)),
    primarySwatch: Colors.teal,
    cardTheme: CardTheme(color: Colors.teal[500]),
    fontFamily: 'Oswald');
