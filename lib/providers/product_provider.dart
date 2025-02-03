import 'package:flutter/material.dart';
import 'package:invetory_management1/models/product_model.dart';
import 'package:invetory_management1/services/firestore_service.dart';

class ProductProvider with ChangeNotifier {
  final FirebaseService _firebaseService = FirebaseService();
  List<Product> _products = [];

  List<Product> get products => _products;

  // Fetch products from Firestore
  Future<void> fetchProducts() async {
    _firebaseService.getProducts().listen((products) {
      _products = products;
      notifyListeners();
    });
  }

  // Add a product
  Future<void> addProduct(Product product) async {
    await _firebaseService.addProduct(product);
    notifyListeners();
  }

  // Delete a product
  Future<void> deleteProduct(String id) async {
    await _firebaseService.deleteProduct(id);
    notifyListeners();
  }

  // Update a product
  Future<void> updateProduct(Product product) async {
    await _firebaseService.updateProduct(product);
    notifyListeners();
  }
}