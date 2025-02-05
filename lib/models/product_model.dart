class Product {
  String id;
  String name;
  String description;
  double price;
  int stock;
  DateTime createdAt;

  Product({
    this.id = '',
    required this.name,
    required this.description,
    required this.price,
    required this.stock,
    required this.createdAt,
  });

  factory Product.fromMap(Map<String, dynamic> data, String id) {
    return Product(
      id: id,
      name: data['name'],
      description: data['description'],
      price: data['price'],
      stock: data['stock'],
      createdAt: DateTime.parse(data['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'price': price,
      'stock': stock,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}