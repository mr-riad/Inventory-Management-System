class SoldProduct {
  final String productId;
  final String productName;
  late final int quantity;
  late final double sellPrice;

  SoldProduct({
    required this.productId,
    required this.productName,
    required this.quantity,
    required this.sellPrice,
  });

  Map<String, dynamic> toMap() {
    return {
      'productId': productId,
      'productName': productName,
      'quantity': quantity,
      'sellPrice': sellPrice,
    };
  }

  factory SoldProduct.fromMap(Map<String, dynamic> data) {
    return SoldProduct(
      productId: data['productId'],
      productName: data['productName'],
      quantity: data['quantity'],
      sellPrice: data['sellPrice'],
    );
  }
}

class Sale {
  final String id;
  final String customerId;
  final String customerName;
  final String customerEmail;
  final String customerPhone;
  final String? customerAddress;
  final List<SoldProduct> soldProducts;
  final double totalPrice;
  double payAmount;
  double borrowAmount;
  final DateTime saleDate;
  List<Map<String, dynamic>> paymentHistory;

  Sale({
    required this.id,
    required this.customerId,
    required this.customerName,
    required this.customerEmail,
    required this.customerPhone,
    this.customerAddress,
    required this.soldProducts,
    required this.totalPrice,
    required this.payAmount,
    required this.borrowAmount,
    required this.saleDate,
    this.paymentHistory = const [],
  });

  factory Sale.fromMap(Map<String, dynamic> data, String id) {
    return Sale(
      id: id,
      customerId: data['customerId'],
      customerName: data['customerName'],
      customerEmail: data['customerEmail'],
      customerPhone: data['customerPhone'],
      customerAddress: data['customerAddress'],
      soldProducts: (data['soldProducts'] as List)
          .map((product) => SoldProduct.fromMap(product))
          .toList(),
      totalPrice: data['totalPrice'],
      payAmount: data['payAmount'],
      borrowAmount: data['borrowAmount'] ?? 0.0,
      saleDate: DateTime.parse(data['saleDate']),
      paymentHistory: List<Map<String, dynamic>>.from(data['paymentHistory'] ?? []),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'customerId': customerId,
      'customerName': customerName,
      'customerEmail': customerEmail,
      'customerPhone': customerPhone,
      'customerAddress': customerAddress,
      'soldProducts': soldProducts.map((product) => product.toMap()).toList(),
      'totalPrice': totalPrice,
      'payAmount': payAmount,
      'borrowAmount': borrowAmount,
      'saleDate': saleDate.toIso8601String(),
      'paymentHistory': paymentHistory,
    };
  }

  void updateBorrowAmount(double newBorrowAmount) {
    borrowAmount = newBorrowAmount;
  }

  void addPaymentRecord(double amount, DateTime date) {
    paymentHistory.add({'amount': amount, 'date': date.toIso8601String()});
    payAmount = amount;
    borrowAmount -= amount;
  }
}