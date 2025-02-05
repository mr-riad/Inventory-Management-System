import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/account_payable_model.dart';

class AccountPayableProvider with ChangeNotifier {
  List<AccountPayable> _accountPayables = [];

  List<AccountPayable> get accountPayables => _accountPayables;

  Future<void> fetchAccountPayables() async {
    final snapshot = await FirebaseFirestore.instance.collection('accountPayables').get();
    _accountPayables = snapshot.docs.map((doc) => AccountPayable.fromMap(doc.data(), doc.id)).toList();
    notifyListeners();
  }

  Future<void> addAccountPayable(AccountPayable accountPayable) async {
    final docRef = await FirebaseFirestore.instance.collection('accountPayables').add(accountPayable.toMap());
    accountPayable.id = docRef.id;
    _accountPayables.add(accountPayable);
    notifyListeners();
  }

  Future<void> updateAccountPayable(AccountPayable accountPayable) async {
    await FirebaseFirestore.instance.collection('accountPayables').doc(accountPayable.id).update(accountPayable.toMap());
    final index = _accountPayables.indexWhere((ap) => ap.id == accountPayable.id);
    _accountPayables[index] = accountPayable;
    notifyListeners();
  }

  Future<void> deleteAccountPayable(String id) async {
    await FirebaseFirestore.instance.collection('accountPayables').doc(id).delete();
    _accountPayables.removeWhere((ap) => ap.id == id);
    notifyListeners();
  }
}