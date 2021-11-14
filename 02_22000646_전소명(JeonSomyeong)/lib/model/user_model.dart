import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class UserModel {
  bool initalized = false;
  String? name;
  String? email;
  String? status_message;
  String? uid;

  UserModel({
    this.name,
    this.email,
    this.status_message,
    this.uid,
  });

  UserModel.fromJsonGoo(Map<String, dynamic> json, String uid)
      : name = json['name'],
        email = json['email'],
        status_message = json['status_message'],
        uid = json['uid'];

  UserModel.fromJsonAnon(Map<String, dynamic> json, String uid)
      : status_message = json['status_message'],
        uid = json['uid'];

  Map<String, dynamic> toJsonGoo() => {
        'name': name,
        'email': email,
        'status_message': status_message,
        'uid': uid,
      };

  Map<String, dynamic> toJsonAnon() => {
        'status_message': status_message,
        'uid': uid,
      };

  UserModel.fromDocumentSnapshot(
      Map<String, dynamic>? doc, bool isAnonymous, User firebaseUser) {
    if (!initalized) {
      Get.offNamed("/");
      initalized = true;
    }

    if (doc == null) {
      print("New user");
      UserModel newUser = UserModel();
      if (isAnonymous) {
        print("Anonymouse Signing up...");
        newUser.uid = firebaseUser.uid;
        newUser.status_message =
            "I promise to take the test honestly before GOD.";
        FirebaseFirestore.instance
            .collection('user')
            .doc(newUser.uid)
            .set(newUser.toJsonAnon());
      } else {
        print("${firebaseUser.displayName} Signing up...");
        newUser.uid = firebaseUser.uid;
        newUser.status_message =
            "I promise to take the test honestly before GOD.";
        newUser.name = firebaseUser.displayName;
        newUser.email = firebaseUser.email;
        FirebaseFirestore.instance
            .collection('user')
            .doc(newUser.uid)
            .set(newUser.toJsonGoo());
      }
      Get.offNamed("/");
      return;
    }
    print("Updating User from Snapshot");
    uid = doc['uid'];
    name = doc['name'];
    email = doc['email'];
    status_message = doc['status_message'];
  }

  @override
  String toString() => "${name ?? 'Anon'} (Uid=$uid)";
}
