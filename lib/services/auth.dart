import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Authentication {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseAuth _auth = FirebaseAuth.instance;

  Future<User?> signIn(String email, String password) async {
    var user = await _auth.signInWithEmailAndPassword(
        email: email, password: password);

    return user.user;
  }

  signOut() async {
    return await _auth.signOut();
  }

  Future<User?> signUp(String email, String name, String password,
      String surname, String company) async {
    var user = await _auth.createUserWithEmailAndPassword(
        email: email, password: password);
    Map<String, String> list = {
      "name": name,
      "mail": email,
      "surname": surname,
      "isletme": company
    };
    await _firestore.collection("users").doc(user.user?.uid).set(list);
    await _firestore
        .collection("users")
        .doc(user.user?.uid)
        .collection("borclular");

    return user.user;
  }
}
