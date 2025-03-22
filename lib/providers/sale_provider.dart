import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:invetory_management1/providers/product_provider.dart';
import 'package:provider/provider.dart';
import '../models/sale_model.dart';

class SaleProvider with ChangeNotifier {
  List<Sale> _sales = [];
  List<Sale> _oldestCustomers = [];
  bool _isLoading = false;

  List<Sale> get sales => _sales;
  List<Sale> get oldestCustomers => _oldestCustomers;
  bool get isLoading => _isLoading;

  // Fetch sales from Firestore
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

  // Fetch oldest customers from Firestore
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

  // Add a new sale to Firestore
  Future<void> addSale(Sale sale, ProductProvider productProvider) async {
    _isLoading = true;
    notifyListeners();

    try {
      // Calculate previous due and total borrow amount
      final previousDue = getPreviousDueForCustomer(sale.customerName);
      final totalBorrowAmount = getTotalBorrowAmountForCustomer(sale.customerName, sale.borrowAmount);

      // Add the sale to Firestore
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

      // Add the sale to the local list
      _sales.add(newSale);

      // Update product stock
      for (var soldProduct in sale.soldProducts) {
        final product = productProvider.products.firstWhere((p) => p.id == soldProduct.productId);
        product.stock -= soldProduct.quantity;
        await productProvider.updateProduct(product);
      }

      // Update the customer's borrow amount in Firestore
      await updateCustomerBorrowAmount(sale.customerName, totalBorrowAmount);

      // Fetch updated sales and customers
      await fetchSales();
      await fetchOldestCustomers();
    } catch (e) {
      log('Error adding sale: $e', name: 'addSale');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Update a sale in Firestore
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

  // Delete a sale from Firestore
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

  // Stream of sales from Firestore
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

  // Update customer details in Firestore
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

  // Add a payment record to a sale
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

  // Get aggregated sales by customer name
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

  // Search customers by name
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

  // Calculate previous due for a customer
  double getPreviousDueForCustomer(String customerName) {
    return _sales
        .where((sale) => sale.customerName == customerName)
        .fold(0.0, (sum, sale) => sum + sale.borrowAmount);
  }

  // Calculate total borrow amount for a customer (including the new sale)
  double getTotalBorrowAmountForCustomer(String customerName, double newBorrowAmount) {
    final previousDue = getPreviousDueForCustomer(customerName);
    return previousDue + newBorrowAmount;
  }

  // Update customer's borrow amount in Firestore
  Future<void> updateCustomerBorrowAmount(String customerName, double totalBorrowAmount) async {
    try {
      // Update the customer's borrow amount in Firestore
      await FirebaseFirestore.instance
          .collection('customers') // Assuming you have a 'customers' collection
          .doc(customerName)
          .update({'totalBorrowAmount': totalBorrowAmount});
    } catch (e) {
      log('Error updating customer borrow amount: $e', name: 'updateCustomerBorrowAmount');
    }
  }

  // Calculate total profit based on filter
  double calculateTotalProfit(BuildContext context, {DateTime? startDate, DateTime? endDate}) {
    double totalProfit = 0.0;
    final products = Provider.of<ProductProvider>(context, listen: false).products;

    for (var sale in _sales) {
      if (startDate != null && endDate != null) {
        // Check if the sale date is within the range (inclusive of startDate and exclusive of endDate)
        if (sale.saleDate.isAfter(startDate.subtract(Duration(days: 1))) && sale.saleDate.isBefore(endDate)) {
          totalProfit += sale.calculateProfit(products);
        }
      } else {
        // If no date range is provided, include all sales
        totalProfit += sale.calculateProfit(products);
      }
    }
    return totalProfit;
  }

  // Filter sales by day
  double calculateDailyProfit(BuildContext context, DateTime date) {
    final startDate = DateTime(date.year, date.month, date.day);
    final endDate = startDate.add(Duration(days: 1));
    return calculateTotalProfit(context, startDate: startDate, endDate: endDate);
  }

  // Filter sales by month
  double calculateMonthlyProfit(BuildContext context, DateTime date) {
    final startDate = DateTime(date.year, date.month, 1);
    final endDate = DateTime(date.year, date.month + 1, 1);
    return calculateTotalProfit(context, startDate: startDate, endDate: endDate);
  }

  // Filter sales by year
  double calculateYearlyProfit(BuildContext context, DateTime date) {
    final startDate = DateTime(date.year, 1, 1);
    final endDate = DateTime(date.year + 1, 1, 1);
    return calculateTotalProfit(context, startDate: startDate, endDate: endDate);
  }

  // Lifetime profit
  double calculateLifetimeProfit(BuildContext context) {
    return calculateTotalProfit(context);
  }
}