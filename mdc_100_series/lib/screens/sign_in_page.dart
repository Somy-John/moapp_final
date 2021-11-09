import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:moappfinal/controller/auth_controller.dart';

class SignInPage extends StatelessWidget {
  final AuthController ac = Get.put(AuthController());
  String _contactText = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: ConstrainedBox(
      constraints: const BoxConstraints.expand(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Image.asset("assets/2.0x/diamond.png",
              width: 100, height: 100, color: Colors.black),
          Column(
            children: [
              SizedBox(
                width: 280,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red.shade300,
                  ),
                  child: const Text(
                    'Sign in with Google',
                    style: TextStyle(fontSize: 17),
                  ),
                  onPressed: ac.signInGoogle,
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              SizedBox(
                width: 280,
                height: 50,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey.shade500,
                  ),
                  child: const Text(
                    'Guest Login',
                    style: TextStyle(fontSize: 17),
                  ),
                  onPressed: ac.signInAnon,
                ),
              ),
            ],
          ),
        ],
      ),
    ));
  }
}

@override
Widget build(BuildContext context) {
  throw UnimplementedError();
}
