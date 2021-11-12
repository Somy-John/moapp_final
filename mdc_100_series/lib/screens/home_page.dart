import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../controller/product_controller.dart';
import '../model/product_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<Image> downloadURL(int id) async {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref()
        .child("product")
        .child("$id.jpeg")
        .getDownloadURL();
    // print(downloadURL);
    return Image.network(downloadURL);
  }

  List<Card> _buildGridCards(BuildContext context) {
    ProductsController pc = Get.put(ProductsController());

    if (pc.products.isEmpty) {
      return const <Card>[];
    }

    final ThemeData theme = Theme.of(context);
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());
    return pc.products.map((product) {
      return Card(
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            FutureBuilder(
                future: downloadURL(product.id),
                builder: (context, AsyncSnapshot<Image> snapshot) {
                  if (snapshot.hasData == false) {
                    return Center(
                      child: Container(
                        // margin: EdgeInsets.only(left: Get.width / 10),
                        padding: EdgeInsets.all(Get.width / 11),
                        child: const CircularProgressIndicator(),
                      ),
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
                    return AspectRatio(
                      aspectRatio: 18 / 11,
                      child: snapshot.data,
                      // Image.network(snapshot.data ?? "NULL")
                    );
                  }
                }),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16.0, 12.0, 16.0, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product.name,
                      style: theme.textTheme.headline6,
                      maxLines: 1,
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      formatter.format(product.price),
                      style: theme.textTheme.subtitle2,
                    ),
                  ],
                ),
              ),
            ),
            // Row(
            //   children: [
            //     SizedBox(
            //       height: 1,
            //     ),

            //   ],
            // )
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(7),
                child: GestureDetector(
                  onTap: () {
                    Get.toNamed('/detail/${product.id}',
                        arguments: product.toJson());
                    // /product?id=${product.id}&creator=${product.creator}&createdtime=${product.createdTime.seconds}&modifiedtime=${product.modifiedTime.seconds}&name=${product.name}&price=${product.price}&desc=${product.desc}&like=${product.like}&likeduser=${product.likedUser}');
                  },
                  child: const Text(
                    "more",
                    style: TextStyle(fontSize: 12, color: Colors.blue),
                  ),
                ),
              ),
            ),
          ],
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.grey.shade700,
        leading: IconButton(
          icon: const Icon(
            Icons.person,
            semanticLabel: 'profile',
          ),
          onPressed: () {
            Get.toNamed("/profile");
          },
        ),
        title: const Text('Main'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(
              Icons.add,
              semanticLabel: 'add',
            ),
            onPressed: () async {
              await Get.toNamed("/add");
              setState(() {});
            },
          ),
        ],
      ),
      body: Center(
        child: GridView.count(
          crossAxisCount: 2,
          padding: const EdgeInsets.all(16.0),
          childAspectRatio: 8.0 / 9.0,
          children: _buildGridCards(context),
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
