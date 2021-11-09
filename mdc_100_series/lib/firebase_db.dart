// import 'dart:async';
// import 'dart:io';

// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:get/get.dart';
// import 'package:handong_ut/controllers/auth_controller.dart';
// import 'package:handong_ut/controllers/status_controller.dart';
// import 'package:handong_ut/controllers/user_controller.dart';
// import 'package:handong_ut/main.dart';
// import 'package:handong_ut/models/status_model.dart';
// import 'package:handong_ut/models/user_model.dart';
// import 'package:handong_ut/uriList.dart';
// import 'package:http/http.dart' as http;

// // TODO: Remove me
// // REF: https://github.com/FirebaseExtended/flutterfire/blob/master/packages/firebase_database/firebase_database/example/lib/main.dart

// class FirebaseDb {
//   StreamSubscription _dataSub;
//   String _uid;

//   String get uid => _uid;

//   // TODO: Get User
//   Future<void> getUser(String uid) async {
//     if (uid != _uid) dispose();
//     _uid = uid;
//     UserController uc = Get.find<UserController>();
//     StatusController sc = Get.find<StatusController>();

//     print("GET USER FROM DB : $uid");
//     // final FirebaseDatabase database = FirebaseDatabase.instance;
//     DatabaseReference dataRef = rtdb.reference().child("users").child(uid);
//     print("Key");
//     print(dataRef.key);

//     dataRef.keepSynced(false);
//     // dataRef.get().then((DataSnapshot snapshot) {
//     //   print(
//     //       'Connected to directly configured database and read ${snapshot.key}');
//     //   print(snapshot.value);
//     // });
//     final notificationToken = await FirebaseMessaging.instance.getToken();
//     AuthController ac = Get.find();
//     final idToken = await ac.user.getIdToken();
//     StreamSubscription _dataSub = dataRef.onValue.listen((Event event) {
//       print("DataSub");
//       print(event.snapshot.value);
//       uc.user = UserModel.fromDocumentSnapshot(event.snapshot);
//       if (event.snapshot != null)
//         sc.status = StatusModel.updateStatusFromSnapshot(event.snapshot);

//       // Check if notification key exists and if it doesn't, add the key.
//       if (!uc.user.notificationTokens.contains(notificationToken)) {
//         print("🔔 NO NOTIFICATION TOKEN");
//         http.post(Uri.parse("$apiUrl/user/add-notification-token"), body: {
//           "token": notificationToken
//         }, headers: {
//           HttpHeaders.authorizationHeader: "Bearer $idToken"
//         }).then((res) => print(res.body));
//       }
//     }, onError: (Object o) {
//       final DatabaseError error = o as DatabaseError;
//       print("DB ERROR");
//       print(error);
//     });

//     // TODO: Figure out to cancel the subscription.
//   }

//   Future<void> dispose() async {
//     print("DB: User Log Out");
//     UserController uc = Get.find<UserController>();
//     _dataSub?.cancel();
//     _uid = null;
//     uc.clear();
//   }
// }
