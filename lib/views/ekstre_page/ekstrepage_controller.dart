import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaselogin/views/ekstre_page/ekstrepage.dart';
import 'package:get/get.dart';

import '../borclularpage/borclularpage_controller.dart';

class EkstrePageController extends GetxController {
  BorclularPageController borclularPageController = Get.find();
  final user = FirebaseAuth.instance.currentUser!;
  var filtre = "Hepsi".obs;
  var bakiye = 0.obs;
  var alacakamountvalue = 0.obs;
  var borcluamountvalue = 0.obs;
  var totalamount = 0.obs;
  var alacakamount = 0;
  var borcamount = 0;
  Future<void> showAmount() async {
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
      bakiye.value = ((borcluamount! + (querylist[i]['amount'])) as int?)!;
    }

    totalamount.value = (borcluamount! + alacakliamount!);
    borcluamountvalue.value = borcluamount;
    alacakamountvalue.value = (-1 * alacakliamount);

    print(borclularPageController.selecteduserid.value);
    print(totalamount);
    print(borcluamount);
    print(alacakliamount);
  }

  dynamic filter(String filtre) {
    FirebaseFirestore firestore = FirebaseFirestore.instance;
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
  }
}
