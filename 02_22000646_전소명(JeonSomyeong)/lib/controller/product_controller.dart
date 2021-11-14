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
    getProductInfo();
    super.onInit();
  }

  late List<ProductModel> _allProducts;
  List<ProductModel> get products => _allProducts;

  List<ProductModel> get productsAsc {
    List<ProductModel> _allProductsAsc = _allProducts;
    _allProductsAsc
        .sort((productA, productB) => productA.price.compareTo(productB.price));
    return _allProductsAsc;
  }

  List<ProductModel> get productsDesc {
    List<ProductModel> _allProductsDesc = _allProducts;
    _allProductsDesc
        .sort((productA, productB) => productB.price.compareTo(productA.price));
    return _allProductsDesc;
  }

  Future getProductInfo() async {
    FirebaseFirestore firestore = FirebaseFirestore.instance;

    final completer = Completer<bool>();

    _productListener = firestore
        // .collection("product")
        .collection("test")
        .doc("products")
        .snapshots()
        .listen((event) {
      final doc = event.data();
      // print(doc);
      _allProducts = (doc as LinkedHashMap).keys.map((item) {
        // print(item);
        return ProductModel(
          id: doc![item]["id"],
          createdTime: doc[item]["createdtime"] as Timestamp,
          modifiedTime: doc[item]["modifiedtime"] as Timestamp,
          creator: doc[item]["creator"],
          name: doc[item]["name"],
          price: doc[item]["price"].runtimeType == int
              ? doc[item]["price"].toDouble()
              : doc[item]["price"],
          desc: doc[item]["desc"],
          like: doc[item]["like"],
          likedUser: doc[item]["likeduser"],
        );
      }).toList();
      if (!completer.isCompleted) completer.complete(true);
    });
    await completer.future;
  }
}
