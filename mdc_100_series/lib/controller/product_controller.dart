import 'dart:async';
import 'dart:collection';

import 'package:get/get.dart';

import '../model/product_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProductsController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  late StreamSubscription<DocumentSnapshot<Map<String, dynamic>>>
      _productListener;

  @override
  onInit() {
    _getProductInfo();
    super.onInit();
  }

  late List<Product> _allProducts;
  List<Product> get products => _allProducts;

  Future _getProductInfo() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    final completer = Completer<bool>();

    Stream<DocumentSnapshot<Map<String, dynamic>>> collectionStream =
        firestore.collection('test').doc('products').snapshots();

    // _productListener = firestore
    //     .collection("product")
    //     .doc("products")
    //     .snapshots()
    _productListener = collectionStream.listen((event) {
      final doc = event.data();
      // print(doc);
      _allProducts = (doc as LinkedHashMap).keys.map((item) {
        // print(item);
        return Product(
          id: doc![item]["id"],
          name: doc[item]["name"],
          price: doc[item]["price"].toDouble(),
          desc: doc[item]["desc"],
        );
      }).toList();
      if (!completer.isCompleted) completer.complete(true);
    });
    await completer.future;
  }
}