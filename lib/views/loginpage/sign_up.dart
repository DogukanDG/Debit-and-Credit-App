import 'package:firebaselogin/views/loginpage/loginpage.dart';
import 'package:firebaselogin/views/loginpage/loginpageController.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controller.dart';
import '../../services/auth.dart';

class SignUp extends StatelessWidget {
  SignUp({Key? key}) : super(key: key);
  final LoginPageController signupcontroller = Get.find();

  @override
  Widget build(BuildContext context) {
    Authentication authentication = new Authentication();
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();
    TextEditingController nameController = TextEditingController();
    TextEditingController surnameController = TextEditingController();
    TextEditingController companyController = TextEditingController();

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Sign Up"),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              signupText(
                nameController,
                "Adınız",
                false,
                Icons.person,
              ),
              signupText(surnameController, "Soyadınız", false, Icons.person),
              signupText(emailController, "Mail", false, Icons.mail),
              buildPassword(passwordController),
              signupText(
                  companyController, "İşletme Adı", false, Icons.business),
              SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  if (nameController.text != null &&
                      nameController.text.length > 3) {
                    authentication
                        .signUp(
                            emailController.text,
                            nameController.text,
                            passwordController.text,
                            surnameController.text,
                            companyController.text)
                        .then((value) => Get.back())
                        .onError((error, stackTrace) {
                      if (error.toString().contains("unknown")) {
                        alertMessage("Email ve Şifre Giriniz");
                      }
                      if (error.toString().contains("Ignoring")) {
                        alertMessage("Bu mail ile bir kullanıcı zaten kayıtlı");
                      }
                    });
                  } else {
                    alertMessage("Lütfen  Adınızı Giriniz");
                  }
                },
                child: Padding(
                  padding:
                      EdgeInsets.only(left: 20, right: 20, top: 10, bottom: 10),
                  child: Text(
                    "Kayıt Ol",
                    style: TextStyle(color: Colors.teal),
                  ),
                ),
                style: ElevatedButton.styleFrom(primary: Colors.grey[300]),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget buildPassword(TextEditingController passwordController) {
    return Obx(
      () => TextField(
        controller: passwordController,
        decoration: InputDecoration(
            enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.teal)),
            labelText: "Şifre",
            labelStyle: TextStyle(color: Colors.teal),
            icon: Padding(
              padding: EdgeInsets.only(top: 20),
              child: Icon(
                Icons.lock,
                color: Colors.teal,
              ),
            ),
            fillColor: Colors.white,
            suffixIcon: IconButton(
              color: Colors.teal,
              icon: signupcontroller.passwordVisible.value
                  ? Icon(Icons.visibility_off)
                  : Icon(Icons.visibility),
              onPressed: () {
                signupcontroller.passwordVisible.value =
                    !signupcontroller.passwordVisible.value;
                //setState(() => passwordVisible = !passwordVisible);
              },
            )),
        cursorColor: Colors.teal,
        style: TextStyle(color: Colors.teal),
        keyboardType: TextInputType.emailAddress,
        textInputAction: TextInputAction.done,
        obscureText: signupcontroller.passwordVisible.value,
      ),
    );
  }
}

Widget signupText(TextEditingController editingController, String labeltext,
    bool obscure, IconData iconData) {
  return TextField(
    obscureText: obscure,
    controller: editingController,
    decoration: InputDecoration(
        enabledBorder:
            UnderlineInputBorder(borderSide: BorderSide(color: Colors.teal)),
        labelText: labeltext,
        labelStyle: TextStyle(color: Colors.teal),
        icon: Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Icon(
            iconData,
            color: Colors.teal,
          ),
        ),
        fillColor: Colors.teal),
    cursorColor: Colors.teal,
    style: TextStyle(color: Colors.teal),
  );
}
