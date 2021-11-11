import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moappfinal/controller/product_controller.dart';
import 'package:moappfinal/model/product_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class AddProduct extends StatefulWidget {
  const AddProduct({Key? key}) : super(key: key);

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  String product_name = 'Unknown', product_description = 'Unknown';
  double product_price = 0.0;
  XFile? imageXfile;
  Image productImage =
      Image.network("http://handong.edu/site/handong/res/img/logo.png");

  @override
  Widget build(BuildContext context) {
    getPhoto() async {
      ImagePicker _picker = ImagePicker();
      XFile? _pickedImage =
          (await _picker.pickImage(source: ImageSource.gallery));
      setState(() {
        imageXfile = _pickedImage;
        productImage = Image.file(File(_pickedImage!.path));
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade700,
        leading: TextButton(
          child: const Text(
            'Cancel',
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text('Add'),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            onPressed: () {
              uploadProduct(
                  imageXfile: imageXfile,
                  name: product_name,
                  price: product_price,
                  desc: product_description);
              Get.back();
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            SizedBox(
              height: Get.height / 2.5,
              width: Get.width,
              child: productImage,
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: IconButton(
                icon: const Icon(
                  Icons.camera_alt,
                  size: 30,
                ),
                onPressed: () {
                  getPhoto();
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(35.0),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "Product Name",
                    ),
                    onChanged: (value) {
                      product_name = value;
                    },
                    onSubmitted: (value) {
                      product_name = value;
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "Price",
                    ),
                    onChanged: (value) {
                      product_price = double.parse(value);
                    },
                    onSubmitted: (value) {
                      product_price = double.parse(value);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    decoration: const InputDecoration(
                      labelText: "Description",
                    ),
                    onChanged: (value) {
                      product_description = value;
                    },
                    onSubmitted: (value) {
                      product_description = value;
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  Future<void> uploadProduct({
    required XFile? imageXfile,
    required String name,
    required double price,
    required String desc,
  }) async {
    // Directory appDocDir = await getApplicationDocumentsDirectory();
    // String filePath = '${appDocDir.absolute}/file-to-upload.png';
    int id = 0;
    ProductsController pc = Get.put(ProductsController());

    Map<String, Map<String, dynamic>> _updatedProducts =
        Map<String, Map<String, dynamic>>();
    for (Product p in pc.products) {
      _updatedProducts[p.id.toString()] = (p.toJson());
      id++;
    }

    Product _productModel =
        Product(id: id, name: name, price: price, desc: desc);
    _updatedProducts[id.toString()] = _productModel.toJson();

    await uploadProductToStore(updatedProducts: _updatedProducts);

    if (imageXfile == Null) {
      var url = "http://handong.edu/site/handong/res/img/logo.png";
      var imageId = await ImageDownloader.downloadImage(url);
      var path = await ImageDownloader.findPath(imageId!);
      print(path);
      await uploadImageToStorage(path!, id.toString());
    } else {
      await uploadImageToStorage(imageXfile!.path, id.toString());
    }
  }

  Future<void> uploadImageToStorage(String filePath, String id) async {
    File file = File(filePath);

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('test/$id.jpeg')
          // .ref('product/$id.jpeg')
          .putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      e.code == 'canceled';
    }
  }

  Future<void> uploadProductToStore({
    required Map<String, Map<String, dynamic>> updatedProducts,
  }) async {
    FirebaseFirestore.instance
        .collection('test')
        // .collection('product')
        .doc('products')
        .set(updatedProducts);
  }
}
