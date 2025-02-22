class Sale {
  final String id;
  final String productId;
  final String customerId;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final int quantity;
  final double sellPrice;
  final double totalPrice;
  final double payAmount;
  double borrowAmount; // Change to non-final to allow updates
  final DateTime saleDate;

  Sale({
    required this.id,
    required this.productId,
    required this.customerId,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    required this.quantity,
    required this.sellPrice,
    required this.totalPrice,
    required this.payAmount,
    required this.borrowAmount,
    required this.saleDate,
  });

  factory Sale.fromMap(Map<String, dynamic> data, String id) {
    return Sale(
      id: id,
      productId: data['productId'],
      customerId: data['customerId'],
      customerName: data['customerName'],
      customerEmail: data['customerEmail'],
      customerPhone: data['customerPhone'],
      quantity: data['quantity'],
      sellPrice: data['sellPrice'],
      totalPrice: data['totalPrice'],
      payAmount: data['payAmount'],
      borrowAmount: data['borrowAmount'] ?? 0.0, // Default to 0 if null
      saleDate: DateTime.parse(data['saleDate']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'customerId': customerId,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'quantity': quantity,
      'sellPrice': sellPrice,
      'totalPrice': totalPrice,
      'payAmount': payAmount,
      'borrowAmount': borrowAmount,
      'saleDate': saleDate.toIso8601String(),
    };
  }

  void updateBorrowAmount(double newBorrowAmount) {
    borrowAmount = newBorrowAmount;
  }
}