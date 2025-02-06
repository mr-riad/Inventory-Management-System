import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../models/account_payable_model.dart';

class AccountPayableProvider with ChangeNotifier {
  List<AccountPayable> _accountPayables = [];

  List<AccountPayable> get accountPayables => _accountPayables;

  // Fetch all account payables from Firestore
  Future<void> fetchAccountPayables() async {
    final snapshot = await FirebaseFirestore.instance.collection('accountPayables').get();
    _accountPayables = snapshot.docs.map((doc) => AccountPayable.fromMap(doc.data(), doc.id)).toList();
    notifyListeners();
  }

  // Add a new account payable to Firestore
  Future<void> addAccountPayable(AccountPayable accountPayable) async {
    try {
      final docRef = await FirebaseFirestore.instance.collection('accountPayables').add(accountPayable.toMap());
      accountPayable.id = docRef.id; // Set the ID of the newly created document
      _accountPayables.add(accountPayable);
      notifyListeners();
    } catch (e) {
      print('Error adding account payable: $e');
    }
  }

  // Update an existing account payable in Firestore
  Future<void> updateAccountPayable(AccountPayable accountPayable) async {
    try {
      await FirebaseFirestore.instance.collection('accountPayables').doc(accountPayable.id).update(accountPayable.toMap());
      final index = _accountPayables.indexWhere((ap) => ap.id == accountPayable.id);
      _accountPayables[index] = accountPayable;
      notifyListeners();
    } catch (e) {
      print('Error updating account payable: $e');
    }
  }

  // Delete an account payable from Firestore
  Future<void> deleteAccountPayable(String id) async {
    try {
      await FirebaseFirestore.instance.collection('accountPayables').doc(id).delete();
      _accountPayables.removeWhere((ap) => ap.id == id);
      notifyListeners();
    } catch (e) {
      print('Error deleting account payable: $e');
    }
  }
}