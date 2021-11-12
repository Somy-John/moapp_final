// enum Category {
//   all,
//   accessories,
//   clothing,
//   home,
// }

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:moappfinal/screens/add_product.dart';

class Product {
  int id;
  String creator;
  String name;
  double price;
  String desc;
  int like;

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
  });

  Product.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        createdTime = json['createdtime'],
        modifiedTime = json['modifiedtime'],
        creator = json['creator'],
        name = json['name'],
        price = json['price'],
        desc = json['desc'],
        like = json['like'];

  Map<String, dynamic> toJson() => {
        '$id.id': id,
        '$id.createdtime': createdTime,
        '$id.modifiedtime': modifiedTime,
        '$id.creator': creator,
        '$id.name': name,
        '$id.price': price,
        '$id.desc': desc,
        '$id.like': like,
      };

  @override
  String toString() => "$name (id=$id)";
}
