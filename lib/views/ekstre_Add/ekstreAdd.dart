import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaselogin/views/ekstre_Add/ekstreAdd_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:firebaselogin/views/borclularpage/borclularpage.dart';
import '../ekstre_page/ekstrepage.dart';
import '../../controller.dart';

class EkstreAdd extends StatelessWidget {
  EkstreAdd({Key? key}) : super(key: key);

  var _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    var _selecteduser = Get.arguments;

    EkstreAddPageController ekstreaddPageController =
        Get.put(EkstreAddPageController());
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    final user = FirebaseAuth.instance.currentUser!;
    TextEditingController typecontroller = TextEditingController();
    TextEditingController _notecontroller = TextEditingController();
    TextEditingController _amountcontroller = TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text("Ekle"),
      ),
      body: GestureDetector(
        onTap: () {
          FocusManager.instance.primaryFocus?.unfocus();
        },
        child: SingleChildScrollView(
          child: Form(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: () async {
                      ekstreaddPageController.selectedate.value =
                          await showDatePicker(
                                context: context,
                                initialDate: _selectedDate,
                                firstDate: DateTime(2000),
                                lastDate: DateTime(2100),
                              ) ??
                              _selectedDate;
                    },
                    child: Card(
                      color: Get.isDarkMode ? Colors.grey[300] : Colors.white,
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: 12,
                          bottom: 12,
                          left: 12,
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.calendar_month,
                              size: 25,
                              color: Colors.black,
                            ),
                            Expanded(
                                child: Container(
                                    child: Obx(
                              () => Text(
                                DateFormat('EEE,MMM d').format(
                                    ekstreaddPageController.selectedate.value),
                                style: TextStyle(color: Colors.black),
                                textAlign: TextAlign.center,
                              ),
                            )))
                          ],
                        ),
                      ),
                    ),
                  ),
                  ekle_Card("Açıklama", _notecontroller, Icons.description),

                  ekle_Card("Miktar", _amountcontroller, Icons.money),
                  Card(
                    color: Get.isDarkMode ? Colors.grey[300] : Colors.white,
                    child: Padding(
                      padding: EdgeInsets.only(left: 16, right: 16, top: 5),
                      child: DropdownButtonFormField(
                        dropdownColor: Get.isDarkMode
                            ? Colors.grey[500]
                            : Colors.grey[200],
                        decoration: InputDecoration(
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.only(left: 12)),
                        value: ekstreaddPageController.type.value,
                        items: ["Borç", "Alacak"]
                            .map((e) => DropdownMenuItem(
                                  child: Text(
                                    e,
                                    style: TextStyle(color: Colors.black),
                                  ),
                                  value: e,
                                ))
                            .toList(),
                        onChanged: (val) {
                          ekstreaddPageController.type.value = val.toString();
                          //print(ekstreaddPageController.type.value);
                        },
                        autofocus: true,
                      ),
                    ),
                  ),
                  //EKLEME YADA ÇIKARMA YAPTIĞIM KISIM

//DATEPİCKER

                  ElevatedButton(
                    onPressed: () {
                      var ordertime = DateTime.now();
                      var list = {
                        "date": _selectedDate,
                        "note": _notecontroller.text,
                        "amount": int.parse(_amountcontroller.text),
                        "type": ekstreaddPageController.type.value,
                        "order": ordertime
                      };
                      firestore
                          .collection("users")
                          .doc(user.uid)
                          .collection("borclular")
                          .doc("${_selecteduser[0]}")
                          .collection("ekstre")
                          .doc()
                          .set(list);
                      Get.back();
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

Widget ekle_Card(String labeltext, TextEditingController editingController,
    IconData iconData) {
  return Card(
    color: Get.isDarkMode ? Colors.grey[300] : Colors.white,
    child: TextField(
      controller: editingController,
      decoration: InputDecoration(
          border: InputBorder.none,
          labelText: labeltext,
          labelStyle: TextStyle(color: Colors.black),
          icon: Padding(
            padding: EdgeInsets.only(left: 10, right: 15),
            child: Icon(
              iconData,
              color: Colors.black,
            ),
          ),
          fillColor: Colors.black),
      cursorColor: Colors.grey,
      style: TextStyle(color: Colors.black),
    ),
  );
}
