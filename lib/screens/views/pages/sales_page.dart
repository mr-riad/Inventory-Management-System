import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/sale_model.dart';
import '../../../providers/product_provider.dart';
import '../../../providers/sale_provider.dart';
class SalesPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final saleProvider = Provider.of<SaleProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Sales'),
      ),
      body: ListView.builder(
        itemCount: saleProvider.sales.length,
        itemBuilder: (context, index) {
          final sale = saleProvider.sales[index];
          final product = productProvider.products.firstWhere((p) => p.id == sale.productId);

          return ListTile(
            title: Text(product.name),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Customer: ${sale.customerName}'),
                Text('Email: ${sale.customerEmail}'),
                Text('Phone: ${sale.customerPhone}'),
                Text('Quantity: ${sale.quantity}, Total: \$${sale.totalPrice.toStringAsFixed(2)}'),
              ],
            ),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                saleProvider.deleteSale(sale.id);
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add sale page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddSalePage(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
class AddSalePage extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final _productIdController = TextEditingController();
  final _quantityController = TextEditingController();
  final _customerNameController = TextEditingController(); // Added customer name controller
  final _customerEmailController = TextEditingController(); // Added customer email controller
  final _customerPhoneController = TextEditingController(); // Added customer phone controller

  @override
  Widget build(BuildContext context) {
    final saleProvider = Provider.of<SaleProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Sale'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _productIdController.text.isEmpty ? null : _productIdController.text,
                items: productProvider.products.map((product) {
                  return DropdownMenuItem(
                    value: product.id,
                    child: Text(product.name),
                  );
                }).toList(),
                onChanged: (value) {
                  _productIdController.text = value!;
                },
                decoration: InputDecoration(labelText: 'Product'),
              ),
              TextFormField(
                controller: _customerNameController, // Added customer name field
                decoration: InputDecoration(labelText: 'Customer Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter customer name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _customerEmailController, // Added customer email field
                decoration: InputDecoration(labelText: 'Customer Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter customer email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _customerPhoneController, // Added customer phone field
                decoration: InputDecoration(labelText: 'Customer Phone'),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter customer phone number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a quantity';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    final product = productProvider.products.firstWhere((p) => p.id == _productIdController.text);
                    final totalPrice = product.buyPrice * int.parse(_quantityController.text);

                    final sale = Sale(
                      id: '', // ID will be generated by Firestore
                      productId: _productIdController.text,
                      customerId: 'customerId', // Replace with actual customer ID
                      customerName: _customerNameController.text, // Added customer name
                      customerEmail: _customerEmailController.text, // Added customer email
                      customerPhone: _customerPhoneController.text, // Added customer phone
                      quantity: int.parse(_quantityController.text),
                      sellPrice: product.buyPrice,
                      totalPrice: totalPrice,
                      saleDate: DateTime.now(),
                    );
                    saleProvider.addSale(sale);
                    Navigator.pop(context);
                  }
                },
                child: Text('Add Sale'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}