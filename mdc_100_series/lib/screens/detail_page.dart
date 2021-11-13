import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:moappfinal/controller/auth_controller.dart';
import 'package:moappfinal/model/product_model.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class DetailPage extends StatefulWidget {
  const DetailPage({Key? key}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Product currentProduct =
      Product.fromJson(Get.arguments, int.parse((Get.parameters['id'])!));
  String downloadURL = '';

  Future<Image> downloadImage(int id) async {
    downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref()
        .child("product")
        .child("$id.jpeg")
        .getDownloadURL();

    return Image.network(downloadURL);
  }

  @override
  Widget build(BuildContext context) {
    AuthController ac = Get.find<AuthController>();
    String currentUID = ac.user!.uid;

    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());

    DateTime createdT = DateTime.fromMicrosecondsSinceEpoch(
        currentProduct.createdTime.seconds * 1000000);
    DateTime modifiedT = DateTime.fromMicrosecondsSinceEpoch(
        currentProduct.modifiedTime.seconds * 1000000);
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
            onPressed: () async {
              if (currentProduct.creator == currentUID) {
                await Get.toNamed('/edit/${currentProduct.id}',
                    arguments: currentProduct.toJson(),
                    parameters: {'URL': downloadURL});
                setState(() {});
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Only creators can edit or delete!',
                        style: TextStyle(fontSize: 17))));
              }
            },
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            onPressed: () async {
              if (currentProduct.creator == currentUID) {
                await deleteProduct(id: currentProduct.id);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Product deleted!',
                        style: TextStyle(fontSize: 17))));
                Get.back();
                setState(() {});
              } else {
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('Only creators can edit or delete!',
                        style: TextStyle(fontSize: 17))));
              }
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          children: [
            FutureBuilder(
                future: downloadImage(currentProduct.id),
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
                        currentProduct.name,
                        style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                              onPressed: () async {
                                if (currentProduct.likedUser
                                    .contains(currentUID)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text(
                                              'You can only do it onece !!',
                                              style: TextStyle(fontSize: 17))));
                                } else {
                                  setState(() {
                                    currentProduct.likeIT(currentUID);
                                  });
                                  await uploadProductToStore(
                                    newProduct: currentProduct.toJson(),
                                  );
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(
                                          content: Text('I LIKE IT!',
                                              style: TextStyle(fontSize: 17))));
                                }
                              },
                              icon: const Icon(
                                Icons.thumb_up,
                                color: Colors.red,
                              )),
                          Text(
                            currentProduct.like.toString(),
                            style: const TextStyle(
                              fontSize: 25,
                              color: Colors.red,
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
                      formatter.format(currentProduct.price),
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
                      currentProduct.desc,
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
                          "Creator : <${currentProduct.creator}>",
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

  Future<void> deleteProduct({required int id}) async {
    await FirebaseFirestore.instance
        .collection('test')
        .doc('products')
        .update({'$id': FieldValue.delete()});

    await firebase_storage.FirebaseStorage.instance
        .ref()
        .child("product")
        .child("$id.jpeg")
        .delete();
  }
}
