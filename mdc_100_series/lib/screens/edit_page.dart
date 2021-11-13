import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:moappfinal/controller/auth_controller.dart';
import 'package:moappfinal/controller/product_controller.dart';
import 'package:moappfinal/model/product_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class EditPage extends StatefulWidget {
  const EditPage({Key? key}) : super(key: key);

  @override
  State<EditPage> createState() => _EditPageState();
}

class _EditPageState extends State<EditPage> {
  Product currentProduct =
      Product.fromJson(Get.arguments, int.parse((Get.parameters['id'])!));

  String product_name = 'Unknown',
      product_description = 'Unknown',
      product_price_string = '0.0';
  double product_price = 0.0;
  XFile? imageXfile;
  Image productImage = Image.network((Get.parameters['URL'])!);

  final _nameController = TextEditingController();
  final _priceController = TextEditingController();
  final _descController = TextEditingController();

  @override
  void initState() {
    super.initState();
    product_name = currentProduct.name;
    product_price = currentProduct.price;
    product_description = currentProduct.desc;

    _nameController.text = product_name;
    _priceController.text = product_price.toString();
    _descController.text = product_description;
    _nameController.addListener(() {
      product_name = _nameController.text;
    });
    _priceController.addListener(() {
      product_price_string = _priceController.text;
      // product_price = double.parse(_priceController.text);
    });
    _descController.addListener(() {
      product_description = _descController.text;
    });
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descController.dispose();
    _priceController.dispose();
    super.dispose();
  }

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
        title: const Text('Edit'),
        actions: <Widget>[
          TextButton(
            child: const Text(
              'Save',
              style: TextStyle(color: Colors.white, fontSize: 12),
            ),
            onPressed: () async {
              await updateProduct(
                imageXfile: imageXfile,
                name: product_name,
                price: double.parse(product_price_string),
                desc: product_description,
                currentProduct: currentProduct,
              );
              Get.back();
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
                    controller: _nameController,
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
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
                    controller: _priceController,
                    style: const TextStyle(
                      fontSize: 25,
                    ),
                    onSubmitted: (value) {
                      product_price = double.parse(value);
                    },
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: _descController,
                    style: const TextStyle(
                      fontSize: 18,
                    ),
                    // selectionHeightStyle: BoxHeightStyle.max,
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

  Future<void> updateProduct({
    required XFile? imageXfile,
    required String name,
    required double price,
    required String desc,
    required Product currentProduct,
  }) async {
    int id = currentProduct.id;

    Map<String, dynamic> _productModel = {
      '$id.id': id,
      '$id.createdtime': currentProduct.createdTime,
      '$id.modifiedtime': FieldValue.serverTimestamp(),
      '$id.creator': currentProduct.creator,
      '$id.name': name,
      '$id.price': price,
      '$id.desc': desc,
      '$id.like': currentProduct.like,
    };

    await uploadProductToStore(
      newProduct: _productModel,
    );

    if (imageXfile != null) {
      await uploadImageToStorage(imageXfile.path, id.toString());
    }
  }

  Future<void> uploadImageToStorage(String filePath, String id) async {
    File file = File(filePath);

    try {
      await firebase_storage.FirebaseStorage.instance
          .ref('product/$id.jpeg')
          .putFile(file);
    } on firebase_core.FirebaseException catch (e) {
      e.code == 'canceled';
    }
  }

  Future<void> uploadProductToStore({
    required Map<String, Object?> newProduct,
  }) async {
    FirebaseFirestore.instance
        .collection('test')
        .doc('products')
        .update(newProduct);
  }

  Future<Image> downloadURL(int id) async {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref()
        .child("product")
        .child("$id.jpeg")
        .getDownloadURL();

    return Image.network(downloadURL);
  }
}
