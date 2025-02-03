import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:invetory_management1/models/product_model.dart';

class FirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Add a product
  Future<void> addProduct(Product product) async {
    await _firestore.collection('products').doc(product.id).set(product.toMap());
  }

  // Delete a product
  Future<void> deleteProduct(String id) async {
    await _firestore.collection('products').doc(id).delete();
  }

  // Update a product
  Future<void> updateProduct(Product product) async {
    await _firestore.collection('products').doc(product.id).update(product.toMap());
  }

  // Get all products
  Stream<List<Product>> getProducts() {
    return _firestore.collection('products').snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => Product.fromMap(doc.data())).toList();
    });
  }
}