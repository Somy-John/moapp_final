import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../controller/product_controller.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ProductsController pc = Get.put(ProductsController());

  final List<String> _valueList = ['ASC', 'DESC'];
  String _selectedValue = 'ASC';

  Future<Image> downloadURL(int id) async {
    String downloadURL = await firebase_storage.FirebaseStorage.instance
        .ref()
        .child("product")
        .child("$id.jpeg")
        .getDownloadURL();
    return Image.network(downloadURL);
  }

  List<Card> _buildGridCards(BuildContext context) {
    if (pc.products.isEmpty) {
      return const <Card>[];
    }

    final ThemeData theme = Theme.of(context);
    final NumberFormat formatter = NumberFormat.simpleCurrency(
        locale: Localizations.localeOf(context).toString());
    return (_selectedValue == 'ASC' ? pc.productsAsc : pc.productsDesc)
        .map((product) {
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
            Align(
              alignment: Alignment.bottomRight,
              child: Padding(
                padding: const EdgeInsets.all(7),
                child: GestureDetector(
                  onTap: () async {
                    await Get.toNamed('/detail/${product.id}',
                        arguments: product.toJson());
                    setState(() {});
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
    pc.getProductInfo();
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: Align(
                alignment: Alignment.center,
                child: DropdownButton(
                  value: _selectedValue,
                  items: _valueList.map((value) {
                    return DropdownMenuItem(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (value) {
                    setState(() {
                      _selectedValue = (value!).toString();
                    });
                  },
                ),
              ),
            ),
            GridView.count(
              shrinkWrap: true,
              crossAxisCount: 2,
              padding: const EdgeInsets.all(16.0),
              childAspectRatio: 8.0 / 9.0,
              children: _buildGridCards(context),
            ),
          ],
        ),
      ),
      resizeToAvoidBottomInset: false,
    );
  }
}
