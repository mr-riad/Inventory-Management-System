class Sale {
  String id;
  String productId;
  String customerId;
  int quantity;
  double totalPrice;
  DateTime saleDate;

  Sale({
    this.id = '',
    required this.productId,
    required this.customerId,
    required this.quantity,
    required this.totalPrice,
    required this.saleDate,
  });

  factory Sale.fromMap(Map<String, dynamic> data, String id) {
    return Sale(
      id: id,
      productId: data['productId'],
      customerId: data['customerId'],
      quantity: data['quantity'],
      totalPrice: data['totalPrice'],
      saleDate: DateTime.parse(data['saleDate']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'customerId': customerId,
      'quantity': quantity,
      'totalPrice': totalPrice,
      'saleDate': saleDate.toIso8601String(),
    };
  }
}