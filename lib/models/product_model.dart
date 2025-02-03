class Product {
  String id;
  String name;
  int stock;
  double price;
  DateTime lastRestocked;
  DateTime lastSold;

  Product({
    required this.id,
    required this.name,
    required this.stock,
    required this.price,
    required this.lastRestocked,
    required this.lastSold,
  });

  // Convert Product to a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'stock': stock,
      'price': price,
      'lastRestocked': lastRestocked.toIso8601String(),
      'lastSold': lastSold.toIso8601String(),
    };
  }

  // Create Product from a Firestore Map
  factory Product.fromMap(Map<String, dynamic> data) {
    return Product(
      id: data['id'],
      name: data['name'],
      stock: data['stock'],
      price: data['price'],
      lastRestocked: DateTime.parse(data['lastRestocked']),
      lastSold: DateTime.parse(data['lastSold']),
    );
  }
}