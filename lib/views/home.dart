import 'package:animated_bottom_navigation_bar/animated_bottom_navigation_bar.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaselogin/coinler/coinler_view.dart';
import 'package:firebaselogin/services/auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'borclularpage/borclularpage.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    Authentication authentication = new Authentication();

    return Scaffold(
      appBar: AppBar(
        title: Text("Ana Sayfa"),
        actions: [
          IconButton(
              onPressed: () {
                Get.isDarkMode
                    ? Get.changeThemeMode(ThemeMode.light)
                    : Get.changeThemeMode(ThemeMode.dark);
              },
              icon: Icon(Icons.dark_mode))
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 10),
        child: Column(
          children: [
            GestureDetector(
              child: HomePageCard(Icons.person, "Kişiler"),
              onTap: () {
                Get.to(BorcluPage());
              },
            ),
            GestureDetector(
              onTap: () {
                Get.to(Coins());
              },
              child: HomePageCard(Icons.currency_bitcoin, "Kripto Borsa"),
            ),
            GestureDetector(
              onTap: () {
                authentication.signOut();
              },
              child:
                  HomePageCard(Icons.door_back_door_outlined, "Oturum Kapat"),
            ),
          ],
        ),
      ),
    );
  }
}

Widget HomePageCard(IconData iconData, String text) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Icon(iconData),
          SizedBox(
            width: 30,
          ),
          Text(text)
        ],
      ),
    ),
  );
}
