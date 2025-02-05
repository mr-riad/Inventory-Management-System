import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/sale_model.dart';

class SaleProvider with ChangeNotifier {
  List<Sale> _sales = [];

  List<Sale> get sales => _sales;

  Future<void> fetchSales() async {
    final snapshot = await FirebaseFirestore.instance.collection('sales').get();
    _sales = snapshot.docs.map((doc) => Sale.fromMap(doc.data(), doc.id)).toList();
    notifyListeners();
  }

  Future<void> addSale(Sale sale) async {
    final docRef = await FirebaseFirestore.instance.collection('sales').add(sale.toMap());
    sale.id = docRef.id;
    _sales.add(sale);
    notifyListeners();
  }

  Future<void> updateSale(Sale sale) async {
    await FirebaseFirestore.instance.collection('sales').doc(sale.id).update(sale.toMap());
    final index = _sales.indexWhere((s) => s.id == sale.id);
    _sales[index] = sale;
    notifyListeners();
  }

  Future<void> deleteSale(String id) async {
    await FirebaseFirestore.instance.collection('sales').doc(id).delete();
    _sales.removeWhere((s) => s.id == id);
    notifyListeners();
  }
}