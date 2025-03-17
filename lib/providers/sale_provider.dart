import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:invetory_management1/providers/product_provider.dart';
import '../models/sale_model.dart';

class SaleProvider with ChangeNotifier {
  List<Sale> _sales = [];
  List<Sale> _oldestCustomers = [];
  bool _isLoading = false;

  List<Sale> get sales => _sales;
  List<Sale> get oldestCustomers => _oldestCustomers;
  bool get isLoading => _isLoading;

  Future<void> fetchSales() async {
    _isLoading = true;
    Future.microtask(() => notifyListeners());

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('sales')
          .orderBy('saleDate', descending: true) // Sort by saleDate in descending order
          .get();
      _sales = snapshot.docs
          .map((doc) => Sale.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
      log(_sales.toString(), name: 'sales');
    } catch (e) {
      log('Error fetching sales: $e', name: 'fetchSales');
    } finally {
      _isLoading = false;
      Future.microtask(() => notifyListeners());
    }
  }

  Future<void> fetchOldestCustomers() async {
    _isLoading = true;
    Future.microtask(() => notifyListeners());

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('sales')
          .orderBy('saleDate', descending: false) // Oldest first
          .limit(5)
          .get();
      _oldestCustomers = snapshot.docs
          .map((doc) => Sale.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    } catch (e) {
      log('Error fetching oldest customers: $e', name: 'fetchOldestCustomers');
    } finally {
      _isLoading = false;
      Future.microtask(() => notifyListeners());
    }
  }

  Future<void> addSale(Sale sale, ProductProvider productProvider) async {
    _isLoading = true;
    notifyListeners();

    try {
      final docRef = await FirebaseFirestore.instance.collection('sales').add(sale.toMap());
      final newSale = Sale(
        id: docRef.id,
        customerId: sale.customerId,
        customerName: sale.customerName,
        customerEmail: sale.customerEmail,
        customerPhone: sale.customerPhone,
        customerAddress: sale.customerAddress,
        soldProducts: sale.soldProducts,
        totalPrice: sale.totalPrice,
        payAmount: sale.payAmount,
        borrowAmount: sale.borrowAmount,
        saleDate: DateTime.now(),
        paymentHistory: sale.paymentHistory,
      );

      _sales.add(newSale);

      for (var soldProduct in sale.soldProducts) {
        final product = productProvider.products.firstWhere((p) => p.id == soldProduct.productId);
        product.stock -= soldProduct.quantity;
        await productProvider.updateProduct(product);
      }
    } catch (e) {
      log('Error adding sale: $e', name: 'addSale');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateSale(Sale sale) async {
    _isLoading = true;
    notifyListeners();

    try {
      await FirebaseFirestore.instance.collection('sales').doc(sale.id).update(sale.toMap());
      final index = _sales.indexWhere((s) => s.id == sale.id);
      if (index != -1) {
        _sales[index] = sale;
      }
    } catch (e) {
      log('Error updating sale: $e', name: 'updateSale');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> deleteSale(String id) async {
    _isLoading = true;
    notifyListeners();

    try {
      await FirebaseFirestore.instance.collection('sales').doc(id).delete();
      _sales.removeWhere((s) => s.id == id);
    } catch (e) {
      log('Error deleting sale: $e', name: 'deleteSale');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Stream<List<Sale>> get salesStream {
    return FirebaseFirestore.instance
        .collection('sales')
        .orderBy('saleDate', descending: true) // Sort by saleDate in descending order
        .snapshots()
        .map((snapshot) {
      return snapshot.docs
          .map((doc) => Sale.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .toList();
    });
  }

  Future<void> updateCustomerDetails(Map<String, dynamic> updatedCustomer) async {
    _isLoading = true;
    notifyListeners();

    try {
      for (var sale in _sales) {
        if (sale.customerId == updatedCustomer['customerId']) {
          await FirebaseFirestore.instance.collection('sales').doc(sale.id).update({
            'customerName': updatedCustomer['customerName'],
            'customerEmail': updatedCustomer['customerEmail'],
            'customerPhone': updatedCustomer['customerPhone'],
            'customerAddress': updatedCustomer['customerAddress'],
          });
        }
      }
    } catch (e) {
      log('Error updating customer details: $e', name: 'updateCustomerDetails');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> addPaymentRecord(String saleId, double amount, DateTime date) async {
    _isLoading = true;
    notifyListeners();

    try {
      final sale = _sales.firstWhere((s) => s.id == saleId);

      sale.paymentHistory.add({'amount': amount, 'date': date.toIso8601String()});
      sale.payAmount = amount; // সর্বশেষ পেমেন্ট হিসাবে সেট করলাম
      sale.borrowAmount -= amount; // Total borrow থেকে পেমেন্ট বাদ দিলাম

      await FirebaseFirestore.instance.collection('sales').doc(saleId).update({
        'borrowAmount': sale.borrowAmount,
        'payAmount': sale.payAmount,
        'paymentHistory': sale.paymentHistory,
      });

      notifyListeners();
    } catch (e) {
      log('Error adding payment record: $e', name: 'addPaymentRecord');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Map<String, List<Sale>> getAggregatedSales() {
    final Map<String, List<Sale>> aggregatedSales = {};

    for (var sale in _sales) {
      if (aggregatedSales.containsKey(sale.customerName)) {
        aggregatedSales[sale.customerName]!.add(sale);
      } else {
        aggregatedSales[sale.customerName] = [sale];
      }
    }

    return aggregatedSales;
  }

  List<Sale> searchCustomers(String query) {
    final allCustomers = _sales
        .where((sale) => sale.customerName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    // Use a Set to filter out duplicate customer names
    final uniqueCustomerNames = <String>{};
    final uniqueCustomers = <Sale>[];

    for (final customer in allCustomers) {
      if (!uniqueCustomerNames.contains(customer.customerName)) {
        uniqueCustomerNames.add(customer.customerName);
        uniqueCustomers.add(customer);
      }
    }

    return uniqueCustomers;
  }

  double getTotalBorrowAmountForCustomer(String customerName) {
    return _sales
        .where((sale) => sale.customerName == customerName)
        .fold(0.0, (sum, sale) => sum + sale.borrowAmount);
  }
}