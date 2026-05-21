class ProductModel {
  int? id;

  String name;
  int price;
  String description;
  String image;

  ProductModel({
    this.id,

    required this.name,

    required this.price,

    required this.description,

    required this.image,
  });

  Map<String, dynamic> toMap() {
    return {
      "id": id,

      "name": name,

      "price": price,

      "description": description,

      "image": image,
    };
  }

  factory ProductModel.fromMap(Map<String, dynamic> map) {
    return ProductModel(
      id: map['id'],

      name: map['name'],

      price: map['price'],

      description: map['description'],

      image: map['image'],
    );
  }
}
