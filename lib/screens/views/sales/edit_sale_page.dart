import 'package:flutter/material.dart';
import 'package:invetory_management1/utils/colors.dart';
import 'package:provider/provider.dart';

import '../../../models/sale_model.dart';
import '../../../providers/product_provider.dart';
import '../../../providers/sale_provider.dart';

class EditSalePage extends StatefulWidget {
  final Sale sale;

  const EditSalePage({super.key, required this.sale});

  @override
  State<EditSalePage> createState() => _EditSalePageState();
}

class _EditSalePageState extends State<EditSalePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _productIdController;
  late TextEditingController _quantityController;
  late TextEditingController _sellPriceController;
  late TextEditingController _payAmountController;
  late TextEditingController _customerNameController;
  late TextEditingController _customerEmailController;
  late TextEditingController _customerPhoneController;

  String? _selectedProductId;

  @override
  void initState() {
    super.initState();
    _productIdController = TextEditingController(text: widget.sale.productId);
    _quantityController = TextEditingController(text: widget.sale.quantity.toString());
    _sellPriceController = TextEditingController(text: widget.sale.sellPrice.toString());
    _payAmountController = TextEditingController(text: widget.sale.payAmount.toString());
    _customerNameController = TextEditingController(text: widget.sale.customerName);
    _customerEmailController = TextEditingController(text: widget.sale.customerEmail);
    _customerPhoneController = TextEditingController(text: widget.sale.customerPhone);
    _selectedProductId = widget.sale.productId;
  }

  @override
  Widget build(BuildContext context) {
    final saleProvider = Provider.of<SaleProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Edit Sale'),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedProductId,
                    items: productProvider.products.map((product) {
                      return DropdownMenuItem(
                        value: product.id,
                        child: Text(
                          product.name,
                          style: const TextStyle(fontSize: 16),
                        ),
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
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  TextFormField(
                    controller: _quantityController,
                    decoration: InputDecoration(
                      labelText: 'Quantity',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _sellPriceController,
                    decoration: InputDecoration(
                      labelText: 'Sell Price',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _payAmountController,
                    decoration: InputDecoration(
                      labelText: 'Pay Amount',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
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

                          final updatedSale = Sale(
                            id: widget.sale.id,
                            productId: _selectedProductId!,
                            customerId: widget.sale.customerId,
                            customerName: _customerNameController.text,
                            customerEmail: _customerEmailController.text,
                            customerPhone: _customerPhoneController.text,
                            quantity: int.parse(_quantityController.text),
                            sellPrice: double.parse(_sellPriceController.text),
                            totalPrice: totalPrice,
                            saleDate: widget.sale.saleDate,
                            payAmount: payAmount,
                            borrowAmount: borrowAmount,
                          );

                          saleProvider.updateSale(updatedSale);
                          Navigator.pop(context);
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: $e')),
                          );
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Update Sale',
                      style: TextStyle(fontSize: 16,),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}