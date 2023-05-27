import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebaselogin/services/auth.dart';
import 'package:firebaselogin/views/home.dart';
import 'package:firebaselogin/views/loginpage/sign_up.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

import '../../controller.dart';
import 'loginpageController.dart';

class LogIn extends StatelessWidget {
  LogIn({Key? key}) : super(key: key);
  //bool passwordVisible = true;
  //TextEditingController passwordController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  LoginPageController loginPageController = Get.put(LoginPageController());

  @override
  Widget build(BuildContext context) {
    loginPageController.passwordTextController.text = "";
    String? mailerror = null;
    String? passworderror = null;
    Authentication authentication = new Authentication();
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.teal[500],
        body: Padding(
          padding: EdgeInsets.all(30),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 70),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "Borç Rehberi",
                          style: TextStyle(
                              fontSize: 45,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Satisfy'),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 100,
                ),
                Padding(
                  padding: const EdgeInsets.only(
                    right: 16.0,
                    left: 16,
                    top: 20,
                  ),
                  child: Container(
                    child: Column(
                      children: [
                        buildMail(emailController),
                        SizedBox(
                          height: 10,
                        ),
                        buildPassword(
                            loginPageController.passwordTextController,
                            passworderror),
                        SizedBox(
                          height: 20,
                        ),
                        GestureDetector(
                          onTap: () {
                            FirebaseAuth.instance
                                .signInWithEmailAndPassword(
                                    email: emailController.text,
                                    password: loginPageController
                                        .passwordTextController.text)
                                .then((value) => null)
                                .catchError((dynamic error) {
                              if (error.toString().contains("wrong-password")) {
                                alertMessage("Şifreniz yanlış");
                              }
                              if (error.toString().contains("user-not-found")) {
                                alertMessage("Kullanıcı bulunamadı");
                              }
                              if (error.toString().contains("invalid-email")) {
                                alertMessage("Mail adresi geçersiz");
                              }
                              print(error.toString());
                            });
                          },
                          child: Container(
                            width: Get.height / 4,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20)),
                            child: Padding(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Text(
                                "Giriş Yap",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: Colors.teal[500], fontSize: 15),
                              ),
                            ),
                          ),
                        ),
                        TextButton(
                          onPressed: () {
                            Get.to(SignUp());
                          },
                          child: Text(
                            "Kayıt Ol",
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                            ),
                          ),
                          style: TextButton.styleFrom(
                            primary: Colors.teal[800],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildPassword(
      TextEditingController passwordController, String? error) {
    return Obx(
      () => TextField(
        controller: passwordController,
        decoration: InputDecoration(
            enabledBorder:
                OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
            labelText: "Şifre",
            labelStyle: TextStyle(color: Colors.white),
            prefixIcon: Icon(
              Icons.lock,
              color: Colors.white,
            ),
            fillColor: Colors.white,
            errorText: error,
            suffixIcon: IconButton(
              icon: loginPageController.passwordVisible.value
                  ? Icon(Icons.visibility_off)
                  : Icon(Icons.visibility),
              onPressed: () {
                loginPageController.passwordVisible.value =
                    !loginPageController.passwordVisible.value;
                //setState(() => passwordVisible = !passwordVisible);
              },
            )),
        cursorColor: Colors.white,
        style: TextStyle(color: Colors.white),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.done,
        obscureText: loginPageController.passwordVisible.value,
      ),
    );
  }

  /* Future<String?> errorMessage(TextEditingController emailAddress,
      TextEditingController password) async {
    var passwordErrorMessage;
    var mailErrorMessage;
    try {
      final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailAddress.text, password: password.text);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        mailErrorMessage = "Kullanıcı bulunamadı";
        return mailErrorMessage;
      } else if (e.code == 'wrong-password') {
        passwordErrorMessage = "Yanlış şifre";
      } else
        return null;
    }
  }*/

  Widget buildMail(TextEditingController emailController) {
    return TextField(
      controller: emailController,
      decoration: InputDecoration(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          labelText: "Email",
          labelStyle: TextStyle(color: Colors.white),
          prefixIcon: Icon(
            Icons.email,
            color: Colors.white,
          ),
          fillColor: Colors.white,
          errorText: null),
      cursorColor: Colors.white,
      style: TextStyle(color: Colors.white),
    );
  }
}

void alertMessage(String text) {
  Fluttertoast.showToast(
    msg: text,
    timeInSecForIosWeb: 1,
    toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    backgroundColor: Colors.grey[600],
    fontSize: 14,
  );
}
