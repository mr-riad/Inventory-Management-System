class Customer {
  String id;
  String name;
  String email;
  String phone;
  DateTime createdAt;

  Customer({
    this.id = '',
    required this.name,
    required this.email,
    required this.phone,
    required this.createdAt,
  });

  factory Customer.fromMap(Map<String, dynamic> data, String id) {
    return Customer(
      id: id,
      name: data['name'],
      email: data['email'],
      phone: data['phone'],
      createdAt: DateTime.parse(data['createdAt']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'phone': phone,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}