import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:moappfinal/screens/add_product.dart';
import 'package:moappfinal/screens/detail_page.dart';
import 'package:moappfinal/screens/home_page.dart';
import 'package:moappfinal/screens/profile_page.dart';
import 'package:moappfinal/screens/sign_in_page.dart';

import 'auth/auth_middleware.dart';
import 'binding/binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseApp app = await Firebase.initializeApp();
  // FirebaseFirestore firestore = FirebaseFirestore.instance;
  // firebase_storage.FirebaseStorage storage =
  //     firebase_storage.FirebaseStorage.instance;
  runApp(MoappFinal());
}

class MoappFinal extends StatelessWidget {
  const MoappFinal({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // darkTheme: ThemeData.dark(),
      debugShowCheckedModeBanner: false,
      initialBinding: Binding(),
      title: 'MoappFinal',
      initialRoute: '/',
      getPages: [
        GetPage(
            name: "/",
            middlewares: [AuthMiddleware()],
            page: () => const HomePage(),
            transition: Transition.noTransition),
        GetPage(
            name: "/login",
            page: () => SignInPage(),
            transition: Transition.fade),
        GetPage(
            name: "/detail/:id",
            page: () => DetailPage(),
            transition: Transition.noTransition),
        GetPage(
            name: "/profile",
            page: () => const ProfilePage(),
            transition: Transition.leftToRight),
        GetPage(
            name: "/add",
            page: () => AddProduct(),
            transition: Transition.rightToLeft),
      ],
    );
  }
}
