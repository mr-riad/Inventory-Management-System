import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../models/product_model.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  String _searchQuery = '';

  List<Product> get products => _products;

  // Getter for filtered products based on search query
  List<Product> get filteredProducts {
    if (_searchQuery.isEmpty) {
      return _products;
    } else {
      return _products
          .where((product) =>
          product.name.toLowerCase().contains(_searchQuery.toLowerCase()))
          .toList();
    }
  }

  // Method to update the search query
  void searchProducts(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  Future<void> fetchProducts() async {
    final snapshot = await FirebaseFirestore.instance.collection('products').get();
    _products = snapshot.docs.map((doc) => Product.fromMap(doc.data(), doc.id)).toList();
    notifyListeners();
  }

  Future<void> addProduct(Product product) async {
    final docRef = await FirebaseFirestore.instance.collection('products').add(product.toMap());
    product.id = docRef.id;
    _products.add(product);
    notifyListeners();
  }

  Future<void> updateProduct(Product product) async {
    await FirebaseFirestore.instance.collection('products').doc(product.id).update(product.toMap());
    final index = _products.indexWhere((p) => p.id == product.id);
    _products[index] = product;
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    await FirebaseFirestore.instance.collection('products').doc(id).delete();
    _products.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}