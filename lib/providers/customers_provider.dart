import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/customers_model.dart';

class CustomerProvider with ChangeNotifier {
  List<Customer> _customers = [];

  List<Customer> get customers => _customers;

  Future<void> fetchCustomers() async {
    final snapshot = await FirebaseFirestore.instance.collection('customers').get();
    _customers = snapshot.docs.map((doc) => Customer.fromMap(doc.data(), doc.id)).toList();
    notifyListeners();
  }

  Future<void> addCustomer(Customer customer) async {
    final docRef = await FirebaseFirestore.instance.collection('customers').add(customer.toMap());
    customer.id = docRef.id;
    _customers.add(customer);
    notifyListeners();
  }

  Future<void> updateCustomer(Customer customer) async {
    await FirebaseFirestore.instance.collection('customers').doc(customer.id).update(customer.toMap());
    final index = _customers.indexWhere((c) => c.id == customer.id);
    _customers[index] = customer;
    notifyListeners();
  }

  Future<void> deleteCustomer(String id) async {
    await FirebaseFirestore.instance.collection('customers').doc(id).delete();
    _customers.removeWhere((c) => c.id == id);
    notifyListeners();
  }
}