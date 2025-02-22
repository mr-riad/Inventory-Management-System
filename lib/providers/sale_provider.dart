import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:invetory_management1/providers/product_provider.dart';

import '../models/sale_model.dart';

class SaleProvider with ChangeNotifier {
  List<Sale> _sales = [];

  List<Sale> get sales => _sales;

  Future<void> fetchSales() async {
    final snapshot = await FirebaseFirestore.instance.collection('sales').get();
    _sales = snapshot.docs
        .map((doc) => Sale.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
    log(_sales.toString(), name: 'sales');
    notifyListeners();
  }

  Future<void> addSale(Sale sale, ProductProvider productProvider) async {
    final docRef = await FirebaseFirestore.instance.collection('sales').add(sale.toMap());
    final newSale = Sale(
      id: docRef.id,
      productId: sale.productId,
      customerId: sale.customerId,
      customerName: sale.customerName,
      customerEmail: sale.customerEmail,
      customerPhone: sale.customerPhone,
      quantity: sale.quantity,
      sellPrice: sale.sellPrice,
      payAmount: sale.payAmount,
      borrowAmount: sale.borrowAmount,
      totalPrice: sale.totalPrice,
      saleDate: sale.saleDate,
    );

    _sales.add(newSale);
    notifyListeners();

    // Update the product stock
    final product = productProvider.products.firstWhere((p) => p.id == sale.productId);
    product.stock -= sale.quantity;
    await productProvider.updateProduct(product);
  }

  Future<void> updateSale(Sale sale) async {
    await FirebaseFirestore.instance.collection('sales').doc(sale.id).update(sale.toMap());
    final index = _sales.indexWhere((s) => s.id == sale.id);
    if (index != -1) {
      _sales[index] = sale;
      notifyListeners();
    }
  }

  Future<void> updateBorrowAmount(String saleId, double newBorrowAmount) async {
    final sale = _sales.firstWhere((s) => s.id == saleId);
    sale.updateBorrowAmount(newBorrowAmount);
    await FirebaseFirestore.instance.collection('sales').doc(saleId).update({'borrowAmount': newBorrowAmount});
    notifyListeners();
  }

  Future<void> deleteSale(String id) async {
    await FirebaseFirestore.instance.collection('sales').doc(id).delete();
    _sales.removeWhere((s) => s.id == id);
    notifyListeners();
  }
}