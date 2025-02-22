import 'package:flutter/material.dart';
import 'package:invetory_management1/utils/colors.dart';
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
        backgroundColor: AppColors.primary,
        title: const Text('Add Sale'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
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
                decoration: InputDecoration(
                  labelText: 'Product',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                hint: const Text('Select a product'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a product';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _customerNameController,
                decoration: InputDecoration(
                  labelText: 'Customer Name',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter customer name';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _customerEmailController,
                decoration: InputDecoration(
                  labelText: 'Customer Email',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter customer email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _customerPhoneController,
                decoration: InputDecoration(
                  labelText: 'Customer Phone',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                keyboardType: TextInputType.phone,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter customer phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _quantityController,
                      decoration: InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
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
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: TextFormField(
                      controller: _sellPriceController,
                      decoration: InputDecoration(
                        labelText: 'Sell Price',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                      ),
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
                  ),
                ],
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: _payAmountController,
                decoration: InputDecoration(
                  labelText: 'Pay Amount',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
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
              const SizedBox(height: 30),
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                child: const Text(
                  'Add Sale',
                  style: TextStyle(fontSize: 16,color: AppColors.textOnPrimary),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}