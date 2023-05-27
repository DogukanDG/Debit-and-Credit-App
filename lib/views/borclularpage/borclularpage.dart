import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaselogin/views/borclu_ekle/borclu_ekle.dart';
import 'package:firebaselogin/views/borclularpage/borclularpage_controller.dart';
import 'package:firebaselogin/views/ekstre_Add/ekstreAdd.dart';
import 'package:firebaselogin/views/ekstre_page/ekstrepage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller.dart';

class BorcluPage extends StatelessWidget {
  BorcluPage({Key? key}) : super(key: key);
  BorclularPageController borclularPageController =
      Get.put(BorclularPageController());
  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    FirebaseFirestore firestore = FirebaseFirestore.instance;
    var borclularRef = firestore
        .collection("users")
        .doc(user.uid)
        .collection("borclular")
        .orderBy("date", descending: true);

    //.orderBy('date', descending: true); Tarihe göre sıralıyor
    TextEditingController _namecontroller = TextEditingController();
    TextEditingController _mailcontroller = TextEditingController();
    TextEditingController _telnocontroller = TextEditingController();
    TextEditingController _moneycontroller = TextEditingController();
    //String bakiye = "0";
    //var _selecteduser;
    return Scaffold(
      appBar: AppBar(
        title: Text("Kişiler"),
        actions: [
          Borc_Ekle(_namecontroller, _mailcontroller, _telnocontroller, context,
              _moneycontroller)
        ],
      ),
      body: Padding(
        padding: EdgeInsets.only(right: 16, left: 16),
        child: Column(
          children: [
            StreamBuilder<QuerySnapshot>(
                stream: borclularRef.snapshots(),
                builder: (BuildContext context, AsyncSnapshot asyncSnapshot) {
                  if (asyncSnapshot.hasData) {
                    List<DocumentSnapshot> list = asyncSnapshot.data.docs;
                    if (list.isNotEmpty) {
                      return Flexible(
                        child: Padding(
                          padding: EdgeInsets.symmetric(vertical: 5),
                          child: ListView.builder(
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                return GestureDetector(
                                    onTap: () {
                                      borclularPageController.selecteduserid
                                          .value = list[index].id;
                                      print(borclularPageController
                                          .selecteduserid.value);
                                      Get.to(() => ekstrePage(), arguments: [
                                        borclularPageController
                                            .selecteduserid.value
                                      ]);
                                    },
                                    child: Column(
                                      children: [
                                        Card(
                                          child: Padding(
                                            padding: const EdgeInsets.all(10.0),
                                            child: ListTile(
                                              trailing: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  //DELETE BUTTON
                                                  IconButton(
                                                      onPressed: () async {
                                                        showDialog(
                                                          context: context,
                                                          builder:
                                                              ((BuildContext
                                                                  context) {
                                                            return AlertDialog(
                                                              backgroundColor: Get
                                                                      .isDarkMode
                                                                  ? Colors
                                                                      .teal[900]
                                                                  : Colors
                                                                      .white,
                                                              actions: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsets
                                                                              .all(
                                                                          20.0),
                                                                  child: Column(
                                                                      children: [
                                                                        Center(
                                                                          child:
                                                                              Text(
                                                                            "Silmek istediğinize emin misiniz?",
                                                                            style: TextStyle(
                                                                                color: Get.isDarkMode ? Colors.white : Colors.teal,
                                                                                fontSize: 18,
                                                                                fontWeight: FontWeight.w500),
                                                                          ),
                                                                        ),
                                                                        Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceEvenly,
                                                                          children: [
                                                                            TextButton(
                                                                                onPressed: () {
                                                                                  Navigator.pop(context);
                                                                                },
                                                                                child: Text(
                                                                                  "Hayır",
                                                                                  style: TextStyle(fontSize: 15, color: Get.isDarkMode ? Colors.white : Colors.teal),
                                                                                )),
                                                                            TextButton(
                                                                              onPressed: () async {
                                                                                var deleteitem = await list[index].reference;
                                                                                deleteitem.delete();
                                                                                Navigator.pop(context);
                                                                              },
                                                                              child: Text(
                                                                                "Evet",
                                                                                style: TextStyle(color: Get.isDarkMode ? Colors.white : Colors.teal, fontSize: 15),
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
                                                      icon: Icon(
                                                        Icons.delete,
                                                        color: Colors.white,
                                                      )),
                                                  //EDİT BUTTON
                                                  IconButton(
                                                      onPressed: () async {
                                                        TextEditingController
                                                            _editname =
                                                            TextEditingController();
                                                        TextEditingController
                                                            _editmail =
                                                            TextEditingController();
                                                        TextEditingController
                                                            _editphoneNo =
                                                            TextEditingController();

                                                        _editmail.text =
                                                            list[index]["mail"];
                                                        _editphoneNo.text =
                                                            list[index]
                                                                ["telefonNo"];
                                                        _editname.text =
                                                            list[index]["name"];

                                                        showDialog(
                                                            context: context,
                                                            builder:
                                                                (BuildContext
                                                                    context) {
                                                              return AlertDialog(
                                                                backgroundColor: Get
                                                                        .isDarkMode
                                                                    ? Colors.teal[
                                                                        900]
                                                                    : Colors
                                                                        .white,
                                                                actions: [
                                                                  Form(
                                                                    child:
                                                                        SingleChildScrollView(
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        children: [
                                                                          Text(
                                                                            "Düzenle",
                                                                            style:
                                                                                TextStyle(
                                                                              color: Get.isDarkMode ? Colors.white : Colors.teal,
                                                                              fontSize: 20,
                                                                            ),
                                                                            textAlign:
                                                                                TextAlign.left,
                                                                          ),
                                                                          SizedBox(
                                                                            height:
                                                                                10,
                                                                          ),
                                                                          textField(
                                                                              _editname,
                                                                              "Ad",
                                                                              Icons.person),
                                                                          textField(
                                                                              _editmail,
                                                                              "Mail",
                                                                              Icons.mail),
                                                                          textField(
                                                                              _editphoneNo,
                                                                              "Telefon No",
                                                                              Icons.phone)
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    height: 20,
                                                                  ),
                                                                  ElevatedButton(
                                                                    //borçlular listesine düzenleme işlemi
                                                                    onPressed:
                                                                        () {
                                                                      var updatelist =
                                                                          {
                                                                        "name":
                                                                            _editname.text,
                                                                        "mail":
                                                                            _editmail.text,
                                                                        "telefonNo":
                                                                            _editphoneNo.text,
                                                                      };

                                                                      firestore
                                                                          .collection(
                                                                              "users")
                                                                          .doc(user
                                                                              .uid)
                                                                          .collection(
                                                                              "borclular")
                                                                          .doc(list[index]
                                                                              .id)
                                                                          .update(
                                                                              updatelist);

                                                                      Navigator.pop(
                                                                          context);
                                                                    },
                                                                    child: Text(
                                                                        "Düzenle"),
                                                                  )
                                                                ],
                                                              );
                                                            });
                                                      },
                                                      icon: Icon(
                                                        Icons.edit,
                                                        color: Colors.white,
                                                      )),
                                                  //buraya detaylar kısmı
                                                  IconButton(
                                                    onPressed: () {
                                                      showDialog(
                                                          context: context,
                                                          builder: (BuildContext
                                                              context) {
                                                            return AlertDialog(
                                                              title: Center(
                                                                child: Text(
                                                                  "Kişi detayları",
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
                                                                  ? Colors
                                                                      .teal[900]
                                                                  : Colors
                                                                      .white,
                                                              actions: [
                                                                Center(
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsets.only(
                                                                        left:
                                                                            20,
                                                                        right:
                                                                            20,
                                                                        bottom:
                                                                            20),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Text(
                                                                          "Mail: ${list[index]["mail"]}",
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              color: Get.isDarkMode ? Colors.white : Colors.teal),
                                                                        ),
                                                                        Text(
                                                                          "TelefonNo: ${list[index]["telefonNo"]}",
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              color: Get.isDarkMode ? Colors.white : Colors.teal),
                                                                        ),
                                                                        Text(
                                                                          "Açıklama: ${list[index]["note"]}",
                                                                          style: TextStyle(
                                                                              fontSize: 15,
                                                                              color: Get.isDarkMode ? Colors.white : Colors.teal),
                                                                        )
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )
                                                              ],
                                                            );
                                                          });
                                                    },
                                                    icon: Icon(Icons.info),
                                                    color: Colors.white,
                                                  )
                                                ],
                                              ),
                                              //BURAYA MAİL VE TELEFON NUMARASI
                                              title: Row(
                                                //BURASI BORCULAR SAYFASINDA GOZUKECEK
                                                children: [
                                                  Text(
                                                    "${list[index]["name"]}",
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        color: Colors.white),
                                                  ),
                                                ],
                                              ),
                                              subtitle: Text(
                                                "Bakiye:${list[index]["bakiye"]}",
                                                style: TextStyle(
                                                    color: Colors.grey[200]),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ));
                              }),
                        ),
                      );
                    } else {
                      return Center(
                          child: Column(
                        children: [
                          SizedBox(height: Get.height / 3),
                          Text(
                            "Lütfen Alacaklı Yada Borçlu Ekleyiniz",
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 18),
                          ),
                          Icon(
                            Icons.warning_amber,
                            color: Colors.grey[600],
                            size: 20,
                          )
                        ],
                      ));
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
                }),
          ],
        ),
      ),
    );
  }
}

Widget textField(TextEditingController editingController, String labeltext,
    IconData iconData) {
  return TextField(
    controller: editingController,
    decoration: InputDecoration(
        labelText: labeltext,
        labelStyle:
            TextStyle(color: Get.isDarkMode ? Colors.white : Colors.teal),
        icon: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Icon(
            iconData,
            color: Get.isDarkMode ? Colors.white : Colors.teal,
          ),
        ),
        fillColor: Get.isDarkMode ? Colors.white : Colors.teal),
    cursorColor: Get.isDarkMode ? Colors.white : Colors.teal,
    style: TextStyle(color: Get.isDarkMode ? Colors.white : Colors.teal),
  );
}

Widget Borc_Ekle(
    TextEditingController _namecontroller,
    TextEditingController _mailcontroller,
    TextEditingController _telnocontroller,
    BuildContext context,
    TextEditingController _moneycontroller) {
  return IconButton(
      //borçlu ekleme işlemi
      onPressed: () {
        Get.to(BorcluEkle());
      },
      icon: Icon(Icons.add));
}

//eklemek için olan kod burda
/*_namecontroller.text = "";
        _mailcontroller.text = "";
        _telnocontroller.text = "";
        _moneycontroller.text = "";
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  "Borçlu ekle",
                  style: TextStyle(color: Colors.white),
                ),
                backgroundColor: Colors.blueGrey,
                content: Container(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        TextField(
                          controller: _namecontroller,
                          decoration: const InputDecoration(
                              labelText: "Borçlu adı",
                              labelStyle: TextStyle(color: Colors.white),
                              icon: Icon(
                                Icons.person,
                                color: Colors.white,
                              ),
                              fillColor: Colors.white),
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                          autofocus: true,
                        ),
                        TextField(
                          controller: _mailcontroller,
                          decoration: const InputDecoration(
                              labelText: "Borçlu maili",
                              labelStyle: TextStyle(color: Colors.white),
                              icon: Icon(
                                Icons.mail,
                                color: Colors.white,
                              ),
                              fillColor: Colors.white),
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                        ),
                        TextField(
                          controller: _telnocontroller,
                          decoration: const InputDecoration(
                              labelText: "Borçlu Telefon Numarası",
                              labelStyle: TextStyle(color: Colors.white),
                              icon: Icon(
                                Icons.phone,
                                color: Colors.white,
                              ),
                              fillColor: Colors.white),
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                        ),
                        TextField(
                          controller: _moneycontroller,
                          decoration: const InputDecoration(
                              labelText: "Miktar",
                              labelStyle: TextStyle(color: Colors.white),
                              icon: Icon(
                                Icons.attach_money,
                                color: Colors.white,
                              ),
                              fillColor: Colors.white),
                          cursorColor: Colors.white,
                          style: TextStyle(color: Colors.white),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          //borçlular listesine ekleme işlemi buraya
                          onPressed: () {
                            var list = {
                              "name": _namecontroller.text,
                              "mail": _mailcontroller.text,
                              "telefonNo": _telnocontroller.text,
                              "amount": int.parse(_moneycontroller.text),
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
              );
            });*/
