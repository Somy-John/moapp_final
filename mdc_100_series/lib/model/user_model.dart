// import 'package:get/get.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class UserModel {
//   bool initalized = false;
//   String id;
//   String name;
//   String email;
//   String hakbun;
//   String groupId;
//   String phoneNo;
//   List notificationTokens = [];

//   UserModel({this.id, this.name, this.phoneNo, this.hakbun});

//   UserModel.fromDocumentSnapshot(DataSnapshot dataSnapshot) {
//     if (!initalized) {
//       Get.offNamed("/");
//       initalized = true;
//     }

//     if (dataSnapshot.value == null) {
//       print("Can't find user from database");
//       Get.offNamed("/newuser");
//       return;
//     }
//     print("Updating User from Snapshot");
//     id = dataSnapshot.key;
//     name = dataSnapshot.value['name'];
//     hakbun = dataSnapshot.value['hakbun'];
//     phoneNo = dataSnapshot.value['phoneNo'];
//     groupId = dataSnapshot.value['groupId'];
//     notificationTokens = dataSnapshot.value["notificationTokens"] ?? [];
//     // email = dataSnapshot.value['email'];
//   }
// }
