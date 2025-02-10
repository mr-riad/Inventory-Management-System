class Sale {
  final String id;
  final String productId;
  final String customerId;
  final String customerName; // Added customerName field
  final String customerEmail; // Added customerEmail field
  final String customerPhone; // Added customerPhone field
  final int quantity;
  final double sellPrice;
  final double totalPrice;
  final double payAmount;
  final double borrowAmount;
  final DateTime saleDate;

  Sale({
    required this.id,
    required this.productId,
    required this.customerId,
    required this.customerName, // Added customerName field
    required this.customerEmail, // Added customerEmail field
    required this.customerPhone, // Added customerPhone field
    required this.quantity,
    required this.sellPrice,
    required this.totalPrice,
    required this.borrowAmount,
    required this.payAmount,
    required this.saleDate,
  });

  // Factory constructor to create a Sale object from a map
  factory Sale.fromMap(Map<String, dynamic> data, String id) {
    return Sale(
      id: id,
      productId: data['productId'],
      customerId: data['customerId'],
      customerName: data['customerName'], // Added customerName field
      customerEmail: data['customerEmail'], // Added customerEmail field
      customerPhone: data['customerPhone'], // Added customerPhone field
      quantity: data['quantity'],
      sellPrice: data['sellPrice'],
      totalPrice: data['totalPrice'],
      payAmount: data['payAmount'],
      borrowAmount: data['borrowAmount'],
      saleDate: DateTime.parse(data['saleDate']),
    );
  }

  // Method to convert a Sale object to a map
  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'customerId': customerId,
      'customerName': customerName, // Added customerName field
      'customerEmail': customerEmail, // Added customerEmail field
      'customerPhone': customerPhone, // Added customerPhone field
      'quantity': quantity,
      'sellPrice': sellPrice,
      'totalPrice': totalPrice,
      'payAmount':payAmount,
      'borrowAmount':borrowAmount,
      'saleDate': saleDate.toIso8601String(),
    };
  }
}