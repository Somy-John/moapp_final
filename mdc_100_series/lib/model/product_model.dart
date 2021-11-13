// enum Category {
//   all,
//   accessories,
//   clothing,
//   home,
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moappfinal/screens/add_page.dart';

class Product {
  int id;
  String creator;
  String name;
  double price;
  String desc;
  int like;
  List likedUser;

  Timestamp createdTime;
  Timestamp modifiedTime;

  Product({
    required this.id,
    required this.createdTime,
    required this.modifiedTime,
    required this.creator,
    required this.name,
    required this.price,
    required this.desc,
    required this.like,
    required this.likedUser,
  });

  Product.fromJson(Map<String, dynamic> json, int id)
      : id = json['$id.id'],
        createdTime = json['$id.createdtime'],
        modifiedTime = json['$id.modifiedtime'],
        creator = json['$id.creator'],
        name = json['$id.name'],
        price = json['$id.price'],
        desc = json['$id.desc'],
        like = json['$id.like'],
        likedUser = json['$id.likeduser'];

  Map<String, dynamic> toJson() => {
        '$id.id': id,
        '$id.createdtime': createdTime,
        '$id.modifiedtime': modifiedTime,
        '$id.creator': creator,
        '$id.name': name,
        '$id.price': price,
        '$id.desc': desc,
        '$id.like': like,
        '$id.likeduser': likedUser,
      };

  void likeIT(String user) {
    like = like + 1;
    likedUser.add(user);
  }

  @override
  String toString() => "$name (id=$id)";
}
