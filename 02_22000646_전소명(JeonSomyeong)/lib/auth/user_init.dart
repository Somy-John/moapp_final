import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:moappfinal/controller/auth_controller.dart';
import 'package:moappfinal/controller/user_controller.dart';
import 'package:moappfinal/model/user_model.dart';

class UserInit {
  StreamSubscription? _dataSub;
  String? _uid;

  String? get uid => _uid;

  Future<void> getUser(User firebaseUser, bool isAnonymous) async {
    String uid = firebaseUser.uid;
    if (uid != _uid) dispose();
    _uid = uid;
    UserController uc = Get.find<UserController>();

    print("GET USER FROM DB : $uid");
    final DocumentReference<Map<String, dynamic>> userRef =
        FirebaseFirestore.instance.collection('user').doc(uid);

    print("UID");
    print(userRef.id);

    AuthController ac = Get.find();
    StreamSubscription _dataSub = userRef.snapshots().listen((event) {
      uc.user = UserModel.fromDocumentSnapshot(
          event.data(), isAnonymous, firebaseUser);
    }, onError: (Object o) {
      print("DB ERROR");
    });
  }

  Future<void> dispose() async {
    print("DB: User Log Out");
    UserController uc = Get.find<UserController>();
    _dataSub?.cancel();
    _uid = null;
    uc.clear();
  }
}
