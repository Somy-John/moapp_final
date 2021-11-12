import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:moappfinal/controller/product_controller.dart';
import 'package:moappfinal/model/product_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase_core/firebase_core.dart' as firebase_core;

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  int id = int.parse((Get.parameters['id'])!);
  bool ifLiked = false;

  Future<Image> downloadURL(int id) async {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref()
        .child("product")
        .child("$id.jpeg")
        .getDownloadURL();
    // print(downloadURL);
    return Image.network(downloadURL);
  }

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());

    Map<String, dynamic> productJson = {
      '$id.id': id,
      '$id.creator': Get.parameters['creator'],
      '$id.createdtime': int.parse((Get.parameters['createdtime'])!),
      '$id.modifiedtime': int.parse((Get.parameters['modifiedtime'])!),
      '$id.name': Get.parameters['name'],
      '$id.price': double.parse((Get.parameters['price'])!),
      '$id.desc': Get.parameters['desc'],
      '$id.like': int.parse((Get.parameters['like'])!),
    };

    DateTime createdT = DateTime.fromMicrosecondsSinceEpoch(
        productJson['$id.createdtime'] * 1000000);
    DateTime modifiedT = DateTime.fromMicrosecondsSinceEpoch(
        productJson['$id.modifiedtime'] * 1000000);
    String createdTS = (createdT.year - 2000).toString() +
        '.' +
        createdT.month.toString() +
        '.' +
        createdT.day.toString() +
        ' ' +
        createdT.hour.toString() +
        ':' +
        createdT.minute.toString() +
        ':' +
        createdT.second.toString();
    String modifiedTS = (createdT.year - 2000).toString() +
        '.' +
        modifiedT.month.toString() +
        '.' +
        modifiedT.day.toString() +
        ' ' +
        modifiedT.hour.toString() +
        ':' +
        modifiedT.minute.toString() +
        ':' +
        modifiedT.second.toString();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade700,
        title: const Align(
          alignment: Alignment(0.23, 0.0),
          child: Text('Detail'),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.create),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () {},
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            FutureBuilder(
                future: downloadURL(id),
                builder: (context, AsyncSnapshot<Image> snapshot) {
                  if (snapshot.hasData == false) {
                    return SizedBox(
                      height: Get.height / 2.5,
                      width: Get.width,
                      child: const Center(
                          child: SizedBox(
                        height: 30,
                        width: 30,
                        child: CircularProgressIndicator(),
                      )),
                    );
                  } else if (snapshot.hasError) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: const TextStyle(fontSize: 15),
                      ),
                    );
                  } else {
                    return SizedBox(
                      height: Get.height / 2.5,
                      width: Get.width,
                      child: snapshot.data,
                    );
                  }
                }),
            Padding(
              padding: const EdgeInsets.all(35.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        (productJson['$id.name'])!,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                setState(() {
                                  if (ifLiked) {
                                    productJson['$id.like'] =
                                        productJson['$id.like'] - 1;
                                  } else {
                                    productJson['$id.like'] =
                                        productJson['$id.like'] + 1;
                                  }

                                  ifLiked = !ifLiked;
                                });
                                await uploadProductToStore(
                                  newProduct: productJson,
                                );
                              },
                              icon: Icon(
                                Icons.thumb_up,
                                color: ifLiked ? Colors.red : Colors.black,
                              )),
                          Text(
                            productJson['$id.like'].toString(),
                            style: TextStyle(
                              fontSize: 25,
                              color: ifLiked ? Colors.red : Colors.black,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      formatter.format(productJson['$id.price']),
                      style: const TextStyle(
                        fontSize: 25,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  const Divider(
                    thickness: 2,
                    height: 20,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      productJson['$id.desc'],
                      style: const TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Creator : <${productJson['$id.creator']}>",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          "$createdTS Created",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                        Text(
                          "$modifiedTS Modified",
                          style: const TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
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

  Future<void> uploadProductToStore({
    required Map<String, Object?> newProduct,
  }) async {
    FirebaseFirestore.instance
        .collection('test')
        .doc('products')
        .update(newProduct);
  }
}
