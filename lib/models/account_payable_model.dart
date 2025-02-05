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

  factory AccountPayable.fromMap(Map<String, dynamic> data, String id) {
    return AccountPayable(
      id: id,
      supplierName: data['supplierName'],
      amountDue: data['amountDue'],
      dueDate: DateTime.parse(data['dueDate']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'supplierName': supplierName,
      'amountDue': amountDue,
      'dueDate': dueDate.toIso8601String(),
    };
  }
}