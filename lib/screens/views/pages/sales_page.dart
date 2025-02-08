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
            subtitle: Text('Quantity: ${sale.quantity}, Total: \$${sale.totalPrice.toStringAsFixed(2)}'),
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
                    final totalPrice = product.price * int.parse(_quantityController.text);

                    final sale = Sale(
                      productId: _productIdController.text,
                      customerId: 'customerId', // Replace with actual customer ID
                      quantity: int.parse(_quantityController.text),
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