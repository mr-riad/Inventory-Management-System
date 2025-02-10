class AccountPayable {
  String id;
  String supplierName;
  double amountDue;
  DateTime dueDate;

  AccountPayable({
    this.id = '',
    required this.supplierName,
    required this.amountDue,
    required this.dueDate,
  });

  // Convert Firestore document to AccountPayable object
  factory AccountPayable.fromMap(Map<String, dynamic> data, String id) {
    return AccountPayable(
      id: id,
      supplierName: data['supplierName'],
      amountDue: data['amountDue'],
      dueDate: data['dueDate'].toDate(), // Convert Firestore Timestamp to DateTime
    );
  }

  // Convert AccountPayable object to Firestore document
  Map<String, dynamic> toMap() {
    return {
      'supplierName': supplierName,
      'amountDue': amountDue,
      'dueDate': dueDate, // Firestore will automatically convert DateTime to Timestamp
    };
  }
}