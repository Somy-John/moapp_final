// enum Category {
//   all,
//   accessories,
//   clothing,
//   home,
// }

class Product {
  // final Category category;
  int id;
  // final bool isFeatured;
  String name;
  double price;
  String desc;

  Product({
    // required this.category,
    required this.id,
    // required this.isFeatured,
    required this.name,
    required this.price,
    required this.desc,
  });

  Product.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        price = json['price'],
        desc = json['desc'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'price': price,
        'desc': desc,
      };

  // String get assetName => '$id-0.jpg';
  // String get assetPackage => 'shrine_images';

  @override
  String toString() => "$name (id=$id)";
}
