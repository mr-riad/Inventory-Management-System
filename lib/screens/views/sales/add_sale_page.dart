import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/sale_model.dart';
import '../../../providers/product_provider.dart';
import '../../../providers/sale_provider.dart';

class AddSalePage extends StatefulWidget {
  const AddSalePage({super.key});

  @override
  State<AddSalePage> createState() => _AddSalePageState();
}

class _AddSalePageState extends State<AddSalePage> {
  final _formKey = GlobalKey<FormState>();
  final _productIdController = TextEditingController();
  final _quantityController = TextEditingController();
  final _sellPriceController = TextEditingController();
  final _payAmountController = TextEditingController();
  final _customerNameController = TextEditingController();
  final _customerEmailController = TextEditingController();
  final _customerPhoneController = TextEditingController();

  String? _selectedProductId;

  @override
  Widget build(BuildContext context) {
    final saleProvider = Provider.of<SaleProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Sale'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                value: _selectedProductId,
                items: productProvider.products.map((product) {
                  return DropdownMenuItem(
                    value: product.id,
                    child: Text(product.name),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _selectedProductId = value;
                  });
                },
                decoration: const InputDecoration(labelText: 'Product'),
                hint: const Text('Select a product'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a product';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _customerNameController,
                decoration: const InputDecoration(labelText: 'Customer Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter customer name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _customerEmailController,
                decoration: const InputDecoration(labelText: 'Customer Email'),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter customer email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _customerPhoneController,
                decoration: const InputDecoration(labelText: 'Customer Phone'),
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
                decoration: const InputDecoration(labelText: 'Quantity'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a quantity';
                  }
                  if (int.tryParse(value) == null || int.parse(value) <= 0) {
                    return 'Please enter a valid quantity';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _sellPriceController,
                decoration: const InputDecoration(labelText: 'Sell Price'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a sell price';
                  }
                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Please enter a valid sell price';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _payAmountController,
                decoration: const InputDecoration(labelText: 'Pay Amount'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a pay amount';
                  }
                  if (double.tryParse(value) == null || double.parse(value) <= 0) {
                    return 'Please enter a valid pay amount';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    try {
                      final product = productProvider.products.firstWhere(
                            (p) => p.id == _selectedProductId,
                      );

                      final totalPrice = double.parse(_sellPriceController.text) * int.parse(_quantityController.text);
                      final payAmount = double.parse(_payAmountController.text);
                      final borrowAmount = totalPrice - payAmount;

                      final sale = Sale(
                        id: '', // ID will be generated by Firestore
                        productId: _selectedProductId!,
                        customerId: 'customerId', // Replace with actual customer ID
                        customerName: _customerNameController.text,
                        customerEmail: _customerEmailController.text,
                        customerPhone: _customerPhoneController.text,
                        quantity: int.parse(_quantityController.text),
                        sellPrice: double.parse(_sellPriceController.text),
                        totalPrice: totalPrice,
                        saleDate: DateTime.now(),
                        payAmount: payAmount,
                        borrowAmount: borrowAmount,
                      );

                      saleProvider.addSale(sale, productProvider); // Pass productProvider here
                      Navigator.pop(context);
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $e')),
                      );
                    }
                  }
                },
                child: const Text('Add Sale'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}