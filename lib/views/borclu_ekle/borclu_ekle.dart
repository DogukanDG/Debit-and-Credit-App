import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controller.dart';
import '../ekstre_Add/ekstreAdd.dart';

class BorcluEkle extends StatelessWidget {
  BorcluEkle({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser!;
    TextEditingController _namecontroller = TextEditingController();
    TextEditingController _mailcontroller = TextEditingController();
    TextEditingController _telnocontroller = TextEditingController();
    TextEditingController _notecontroller = TextEditingController();
    _namecontroller.text = "";
    _mailcontroller.text = "";
    _telnocontroller.text = "";

    return Scaffold(
      appBar: AppBar(
        title: Text("Borçlu Ekle"),
      ),
      body: Form(
        child: GestureDetector(
          onTap: () {
            FocusManager.instance.primaryFocus?.unfocus();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  ekle_Card("Borçlu Adı", _namecontroller, Icons.person),
                  ekle_Card("Borçlu Maili", _mailcontroller, Icons.mail),
                  ekle_Card(
                      "Borçlu Telefon Numarası", _telnocontroller, Icons.phone),
                  ekle_Card("Açıklama", _notecontroller, Icons.description),
                  SizedBox(
                    height: 10,
                  ),
                  ElevatedButton(
                    //borçlular listesine ekleme işlemi buraya
                    onPressed: () {
                      var list = {
                        "date": DateTime.now(),
                        "name": _namecontroller.text,
                        "mail": _mailcontroller.text,
                        "telefonNo": _telnocontroller.text,
                        "note": _notecontroller.text,
                        "bakiye": 0,
                      };
                      firestore
                          .collection("users")
                          .doc(user.uid)
                          .collection("borclular")
                          .doc()
                          .set(list);

                      Navigator.pop(context);
                    },
                    child: Text("Ekle"),
                  ),
                  SizedBox(
                    height: 40,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
