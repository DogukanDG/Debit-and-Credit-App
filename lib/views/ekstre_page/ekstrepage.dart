import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaselogin/views/borclularpage/borclularpage_controller.dart';
import 'package:firebaselogin/views/ekstre_Add/ekstreAdd.dart';
import 'package:firebaselogin/views/ekstre_page/ekstrepage_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controller.dart';

class ekstrePage extends StatelessWidget {
  ekstrePage({Key? key}) : super(key: key);
  //var filtre = "Hepsi";
  var userinfo = Get.arguments;
  final user = FirebaseAuth.instance.currentUser!;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  EkstrePageController ekstrePageController = Get.put(EkstrePageController());
  BorclularPageController borclularPageController = Get.find();

  @override
  @override
  Widget build(BuildContext context) {
    //var data = Get.arguments;
    //var docpointer = data[0];
    var ekstreRef = firestore
        .collection("users")
        .doc(user.uid)
        .collection("borclular")
        .doc(borclularPageController.selecteduserid.value)
        .collection("ekstre")
/*.where("type", isEqualTo: 'Borç')*/
        .orderBy("order", descending: true);
    ekstreRef = ekstrePageController.filter(ekstrePageController.filtre.value);
    ekstrePageController.showAmount();
    return Scaffold(
      appBar: AppBar(
        title: Text("Borçlar/Alacaklar"),
        actions: [
          Add(context),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(left: 16, right: 16, top: 16),
        child: Obx(() => Column(
              children: [
                Align(
                  alignment: Alignment.centerRight,
                  child: DropdownButton(
                      value: ekstrePageController.filtre.value,
                      dropdownColor:
                          Get.isDarkMode ? Colors.grey[500] : Colors.grey[200],
                      style: TextStyle(
                          color: Get.isDarkMode ? Colors.white : Colors.teal,
                          fontSize: 15),
                      items: ["Hepsi", "Borç", "Alacak"]
                          .map((e) => DropdownMenuItem(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      left: 20, right: 20, top: 10, bottom: 10),
                                  child: Text(e),
                                ),
                                value: e,
                              ))
                          .toList(),
                      onChanged: (value) {
                        ekstrePageController.filtre.value = value.toString();
                        ekstreRef =
                            ekstrePageController.filter(value.toString());
                      }),
                ),
                StreamBuilder<QuerySnapshot>(
                  stream: ekstreRef.snapshots(),
                  builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                    if (asyncSnapshot.hasData) {
                      List<DocumentSnapshot> ekstrelist =
                          asyncSnapshot.data.docs;
                      if (ekstrelist.isNotEmpty) {
                        return Flexible(
                          child: RefreshIndicator(
                            onRefresh: ekstrePageController.showAmount,
                            child: ListView.builder(
                              itemCount: ekstrelist.length,
                              itemBuilder: (context, index) {
                                var timestamp = ekstrelist[index]["date"];
                                var time = DateTime.parse(
                                    timestamp.toDate().toString());
                                var date =
                                    DateFormat('MMM d,yyyy').format(time);
                                return Stack(
                                  children: [
                                    Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.only(
                                                  topLeft: Radius.circular(10),
                                                  topRight:
                                                      Radius.circular(10)),
                                              color: Get.isDarkMode
                                                  ? Color(0xff2C3333)
                                                  : Color(0xffD1D1D1)),
                                          height: Get.height / 10,
                                          child: Padding(
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Container(
                                                    child: Text("${date}")),
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      right: 30),
                                                  child: Text(
                                                      "${ekstrelist[index]["amount"]}",
                                                      style: TextStyle(
                                                        fontSize: 20,
                                                        color: condition(
                                                            "${ekstrelist[index]["type"]}"),
                                                      )),
                                                ),
                                                Text(
                                                  "${ekstrelist[index]["type"]}",
                                                  style: TextStyle(
                                                      fontFamily: 'Oswald'),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Row(
                                          children: [
                                            GestureDetector(
                                              onTap: () async {
                                                showDialog(
                                                  context: context,
                                                  builder:
                                                      ((BuildContext context) {
                                                    return AlertDialog(
                                                      backgroundColor:
                                                          Get.isDarkMode
                                                              ? Colors.teal[900]
                                                              : Colors.white,
                                                      actions: [
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.all(
                                                                  20.0),
                                                          child: Column(
                                                              children: [
                                                                Center(
                                                                  child: Text(
                                                                    "Silmek istediğinize emin misiniz?",
                                                                    style: TextStyle(
                                                                        color: Get.isDarkMode
                                                                            ? Colors
                                                                                .white
                                                                            : Colors
                                                                                .teal,
                                                                        fontSize:
                                                                            18,
                                                                        fontWeight:
                                                                            FontWeight.w500),
                                                                  ),
                                                                ),
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .spaceEvenly,
                                                                  children: [
                                                                    TextButton(
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              context);
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          "Hayır",
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              color: Get.isDarkMode ? Colors.white : Colors.teal),
                                                                        )),
                                                                    TextButton(
                                                                      onPressed:
                                                                          () async {
                                                                        var deleteitem =
                                                                            await ekstrelist[index].reference;
                                                                        deleteitem
                                                                            .delete()
                                                                            .then((value) =>
                                                                                ekstrePageController.showAmount().then((value) => borcluPageBakiye()));
                                                                        Navigator.pop(
                                                                            context);
                                                                      },
                                                                      child:
                                                                          Text(
                                                                        "Evet",
                                                                        style: TextStyle(
                                                                            color: Get.isDarkMode
                                                                                ? Colors.white
                                                                                : Colors.teal,
                                                                            fontSize: 15),
                                                                      ),
                                                                    ),
                                                                  ],
                                                                )
                                                              ]),
                                                        )
                                                      ],
                                                    );
                                                  }),
                                                );
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomLeft:
                                                        Radius.circular(10),
                                                  ),
                                                  color: Colors.grey[600],
                                                ),
                                                width: (Get.width / 3) - 16,
                                                child: Center(
                                                    child: Icon(Icons.delete)),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                TextEditingController
                                                    editamount =
                                                    TextEditingController();
                                                TextEditingController editnote =
                                                    TextEditingController();

                                                editamount.text =
                                                    ekstrelist[index]["amount"]
                                                        .toString();
                                                editnote.text =
                                                    ekstrelist[index]["note"];

                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        title: Center(
                                                          child: Text(
                                                            "Düzenle",
                                                            style: TextStyle(
                                                                color: Get.isDarkMode
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .teal),
                                                          ),
                                                        ),
                                                        backgroundColor: Get
                                                                .isDarkMode
                                                            ? Colors.teal[900]
                                                            : Colors.white,
                                                        actions: [
                                                          Form(
                                                            child: Column(
                                                              children: [
                                                                TextField(
                                                                  controller:
                                                                      editamount,
                                                                  decoration: InputDecoration(
                                                                      labelText: "Miktar adı",
                                                                      labelStyle: TextStyle(color: Get.isDarkMode ? Colors.white : Colors.teal),
                                                                      icon: Icon(
                                                                        Icons
                                                                            .money,
                                                                        color: Get.isDarkMode
                                                                            ? Colors.white
                                                                            : Colors.teal,
                                                                      ),
                                                                      fillColor: Colors.teal),
                                                                  cursorColor:
                                                                      Colors
                                                                          .teal,
                                                                  style: TextStyle(
                                                                      color: Get.isDarkMode
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .teal),
                                                                  autofocus:
                                                                      true,
                                                                ),
                                                                TextField(
                                                                  controller:
                                                                      editnote,
                                                                  decoration: InputDecoration(
                                                                      labelText: "Note",
                                                                      labelStyle: TextStyle(color: Get.isDarkMode ? Colors.white : Colors.teal),
                                                                      icon: Icon(
                                                                        Icons
                                                                            .note,
                                                                        color: Get.isDarkMode
                                                                            ? Colors.white
                                                                            : Colors.teal,
                                                                      ),
                                                                      fillColor: Get.isDarkMode ? Colors.white : Colors.teal),
                                                                  cursorColor:
                                                                      Colors
                                                                          .white,
                                                                  style: TextStyle(
                                                                      color: Get.isDarkMode
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .teal),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          SizedBox(
                                                            height: 50,
                                                          ),
                                                          ElevatedButton(
                                                            onPressed: () {
                                                              var updatelist = {
                                                                "amount": int.parse(
                                                                    editamount
                                                                        .text),
                                                                "note": editnote
                                                                    .text,
                                                              };
                                                              firestore
                                                                  .collection(
                                                                      "users")
                                                                  .doc(user.uid)
                                                                  .collection(
                                                                      "borclular")
                                                                  .doc(borclularPageController
                                                                      .selecteduserid
                                                                      .value)
                                                                  .collection(
                                                                      "ekstre")
                                                                  .doc(ekstrelist[
                                                                          index]
                                                                      .id)
                                                                  .update(
                                                                      updatelist)
                                                                  .then((value) => ekstrePageController
                                                                      .showAmount()
                                                                      .then((value) =>
                                                                          borcluPageBakiye()));
                                                              //bakiyeyi kişiler sayfasında göstermek
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child:
                                                                Text("Düzenle"),
                                                          )
                                                        ],
                                                      );
                                                    });
                                              },
                                              child: Container(
                                                color: Colors.grey[700],
                                                width: (Get.width / 3),
                                                child: Icon(
                                                  Icons.edit,
                                                ),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        backgroundColor: Get
                                                                .isDarkMode
                                                            ? Colors.teal[900]
                                                            : Colors.white,
                                                        title: Center(
                                                          child: Text(
                                                            "Açıklama",
                                                            style: TextStyle(
                                                                color: Get.isDarkMode
                                                                    ? Colors
                                                                        .white
                                                                    : Colors
                                                                        .teal),
                                                          ),
                                                        ),
                                                        actions: [
                                                          SingleChildScrollView(
                                                            child: Container(
                                                              child: Center(
                                                                child: Text(
                                                                  "${ekstrelist[index]["note"]}",
                                                                  style: TextStyle(
                                                                      color: Get.isDarkMode
                                                                          ? Colors
                                                                              .white
                                                                          : Colors
                                                                              .teal),
                                                                ),
                                                              ),
                                                            ),
                                                          )
                                                        ],
                                                      );
                                                    });
                                              },
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    bottomRight:
                                                        Radius.circular(10),
                                                  ),
                                                  color: Get.isDarkMode
                                                      ? Colors.grey[800]
                                                      : Colors.grey[800],
                                                ),
                                                width: (Get.width / 3) - 16,
                                                child: Center(
                                                  child: Icon(Icons.info),
                                                ),
                                              ),
                                            )
                                          ],
                                        ),
                                        SizedBox(
                                          height: 10,
                                        )
                                      ],
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                        );
                      } else {
                        return Expanded(
                          child: Container(
                            child: Column(
                              children: [
                                SizedBox(
                                  height: (Get.height / 4),
                                ),
                                Center(
                                    child: Text(
                                  "Lütfen borç yada alacak ekleyiniz",
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                )),
                                Icon(
                                  Icons.warning_amber,
                                  size: 45,
                                  color: Colors.grey,
                                )
                              ],
                            ),
                          ),
                        );
                      }
                    } else if (asyncSnapshot.hasError) {
                      return SafeArea(
                        child: Center(
                          child: Text("HATA"),
                        ),
                      );
                    } else {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                  },
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      color: Color(0xffD1D1D1),
                    ),
                    height: Get.height / 10,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "Bakiye:${ekstrePageController.totalamount.value}",
                            style: TextStyle(color: Colors.grey, fontSize: 20),
                          ),
                          Text(
                            "Borç:${ekstrePageController.borcluamountvalue.value}",
                            style: TextStyle(color: Colors.green, fontSize: 20),
                          ),
                          Text(
                            "Alacak:${ekstrePageController.alacakamountvalue.value}",
                            style: TextStyle(color: Colors.red, fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            )),
      ),
    );
  }

  /*void initState() {
    super.initState();
    showAmount().then((value) => borcluPageBakiye());

    print(borclularPageController.selecteduserid.value);
  }*/

  /*Future<void> showAmount() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var ekstreRef = firestore
        .collection("users")
        .doc(user.uid)
        .collection("borclular")
        .doc(borclularPageController.selecteduserid.value)
        .collection("ekstre")
        .orderBy("order", descending: true);
    var queryResponse = await ekstreRef.get();
    var querylist = queryResponse.docs; //zarflı hale getiriyor documanları
    //querysnapshot??
    // bu listenin içinde neler var
    int? alacakliamount = 0;
    int? borcluamount = 0;

    for (int i = 0; i < querylist.length; i++) {
      if (querylist[i]["type"] == "Alacak") {
        alacakliamount = (alacakliamount! - (querylist[i]['amount'])) as int?;
      } else if (querylist[i]["type"] == "Borç") {
        borcluamount = (borcluamount! + (querylist[i]['amount'])) as int?;
      }
      bakiye = (borcluamount! + (querylist[i]['amount'])) as int?;
    }
    totalamount = 0;

    totalamount = borcluamount! + alacakliamount!;
    borcluamountvalue = borcluamount;
    alacakamountvalue = -1 * alacakliamount;
  }*/
  Color? condition(String condition) {
    if (condition == "Borç") {
      return Color(0xff3CCF4E);
    } else if (condition == "Alacak") {
      color:
      return Colors.red;
    }
  }

  Widget Add(
    BuildContext context,
  ) {
    return IconButton(
        onPressed: () {
          Get.to(
            () => EkstreAdd(),
            arguments: [borclularPageController.selecteduserid.value],
          )?.then((value) => ekstrePageController
              .showAmount()
              .then((value) => borcluPageBakiye()));
        },
        icon: Icon(Icons.add));
  }

  Future<void> borcluPageBakiye() {
    return firestore
        .collection("users")
        .doc(user.uid)
        .collection("borclular")
        .doc(borclularPageController.selecteduserid.value)
        .update({"bakiye": ekstrePageController.totalamount.value});
  }

  /*dynamic filter(String filtre) {
    var ekstreRef;
    if (filtre == "Hepsi") {
      return ekstreRef = firestore
          .collection("users")
          .doc(user.uid)
          .collection("borclular")
          .doc(borclularPageController.selecteduserid.value)
          .collection("ekstre")
          .orderBy("order", descending: true);
    } else if (filtre == "Borç") {
      return ekstreRef = firestore
          .collection("users")
          .doc(user.uid)
          .collection("borclular")
          .doc(borclularPageController.selecteduserid.value)
          .collection("ekstre")
          .where("type", isEqualTo: 'Borç')
          .orderBy("order", descending: true);
    } else if (filtre == "Alacak") {
      return ekstreRef = firestore
          .collection("users")
          .doc(user.uid)
          .collection("borclular")
          .doc(borclularPageController.selecteduserid.value)
          .collection("ekstre")
          .where("type", isEqualTo: 'Alacak')
          .orderBy("order", descending: true);
    }
  }*/
}
