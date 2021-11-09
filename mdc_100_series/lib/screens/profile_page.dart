import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:moappfinal/controller/auth_controller.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    AuthController ac = Get.find<AuthController>();
    User? currentUser = ac.user;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.exit_to_app,
              semanticLabel: 'logout',
            ),
            onPressed: () {
              ac.signOut();
              Get.offAllNamed("/login");
            },
          ),
        ],
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: Get.width / 7),
          width: Get.width,
          color: Colors.black,
          child: Column(
            children: [
              SizedBox(
                height: Get.height / 4,
                width: Get.height / 4,
                child: Image.network(
                  currentUser != null
                      ? currentUser.photoURL ??
                          "http://handong.edu/site/handong/res/img/logo.png"
                      : "NULL",
                  fit: BoxFit.contain,
                ),
              ),

              SizedBox(
                height: Get.height / 10,
              ),
              Text(
                "<${currentUser != null ? currentUser.uid : "NULL"}>",
                style: const TextStyle(color: Colors.white, fontSize: 30),
              ),
              Divider(
                color: Colors.white,
                thickness: 1,
                height: Get.height / 10,
              ),
              Text(
                currentUser != null
                    ? currentUser.email ?? "\"Anonymous\""
                    : "NULL",
                style: const TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: Get.height / 10,
              ),
              const Text(
                "Somyeong Jeon",
                style: TextStyle(color: Colors.white, fontSize: 20),
                textAlign: TextAlign.left,
              ),
              SizedBox(
                height: 10,
              ),
              const Text(
                "I promise to take the test honestly before GOD .",
                style: TextStyle(color: Colors.white, fontSize: 16),
                textAlign: TextAlign.left,
              ),
              // GetX<AuthController>(
              //     init: AuthController(),
              //     builder: (_) => Image.network(_.user!.photoURL ?? "")),
              // GetX<AuthController>(
              //   init: AuthController(),
              //   builder: (_) => Text(
              //     _.user!.uid,
              //     style: const TextStyle(
              //       fontSize: 9,
              //       color: Color(0xFF969696),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}
