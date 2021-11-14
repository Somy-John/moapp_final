import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'package:moappfinal/provider/login_provider.dart';
import 'package:moappfinal/screens/add_page.dart';
import 'package:moappfinal/screens/detail_page.dart';
import 'package:moappfinal/screens/edit_page.dart';
import 'package:moappfinal/screens/home_page.dart';
import 'package:moappfinal/screens/profile_page.dart';
import 'package:moappfinal/screens/sign_in_page.dart';
import 'package:provider/provider.dart';

import 'auth/auth_middleware.dart';
import 'binding/binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  FirebaseApp app = await Firebase.initializeApp();
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
            page: () => ChangeNotifierProvider<LoginProvider>(
                create: (_) => LoginProvider(), child: HomePage()),
            transition: Transition.fadeIn),
        GetPage(
            name: "/login",
            page: () => SignInPage(),
            transition: Transition.fade),
        GetPage(
            name: "/detail/:id",
            page: () => const DetailPage(),
            transition: Transition.fadeIn),
        GetPage(
            name: "/profile",
            page: () => const ProfilePage(),
            transition: Transition.leftToRight),
        GetPage(
            name: "/add",
            page: () => const AddPage(),
            transition: Transition.rightToLeft),
        GetPage(
            name: "/edit/:id",
            page: () => const EditPage(),
            transition: Transition.fadeIn),
      ],
    );
  }
}
