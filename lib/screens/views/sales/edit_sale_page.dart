import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:invetory_management1/models/sale_model.dart';
import 'package:invetory_management1/providers/product_provider.dart';
import 'package:invetory_management1/providers/sale_provider.dart';
import 'package:invetory_management1/utils/colors.dart';

class EditSalePage extends StatefulWidget {
  final Sale sale;

  const EditSalePage({super.key, required this.sale});

  @override
  State<EditSalePage> createState() => _EditSalePageState();
}

class _EditSalePageState extends State<EditSalePage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _customerNameController;
  late TextEditingController _customerEmailController;
  late TextEditingController _customerPhoneController;
  late TextEditingController _payAmountController;

  List<SoldProduct> _soldProducts = [];

  @override
  void initState() {
    super.initState();
    _customerNameController = TextEditingController(text: widget.sale.customerName);
    _customerEmailController = TextEditingController(text: widget.sale.customerEmail);
    _customerPhoneController = TextEditingController(text: widget.sale.customerPhone);
    _payAmountController = TextEditingController(text: widget.sale.payAmount.toString());
    _soldProducts = List.from(widget.sale.soldProducts);
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
                  const SizedBox(height: 20),
                  ..._soldProducts.map((soldProduct) {
                    return _buildSoldProductItem(soldProduct, productProvider);
                  }).toList(),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        try {
                          final totalPrice = _soldProducts.fold(0.0, (sum, product) => sum + (product.sellPrice * product.quantity));
                          final payAmount = double.parse(_payAmountController.text);
                          final borrowAmount = totalPrice - payAmount;

                          final updatedSale = Sale(
                            id: widget.sale.id,
                            customerId: widget.sale.customerId,
                            customerName: _customerNameController.text,
                            customerEmail: _customerEmailController.text,
                            customerPhone: _customerPhoneController.text,
                            customerAddress: widget.sale.customerAddress,
                            soldProducts: _soldProducts,
                            totalPrice: totalPrice,
                            payAmount: payAmount,
                            borrowAmount: borrowAmount,
                            saleDate: widget.sale.saleDate,
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
                      style: TextStyle(fontSize: 16),
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

  Widget _buildSoldProductItem(SoldProduct soldProduct, ProductProvider productProvider) {
    final product = productProvider.products.firstWhere((p) => p.id == soldProduct.productId);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              product.name,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Quantity: ${soldProduct.quantity}'),
            Text('Sell Price: \$${soldProduct.sellPrice.toStringAsFixed(2)}'),
            Text('Total: \$${(soldProduct.quantity * soldProduct.sellPrice).toStringAsFixed(2)}'),
            const SizedBox(height: 8),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    _editSoldProduct(soldProduct);
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      _soldProducts.remove(soldProduct);
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _editSoldProduct(SoldProduct soldProduct) {
    final quantityController = TextEditingController(text: soldProduct.quantity.toString());
    final sellPriceController = TextEditingController(text: soldProduct.sellPrice.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Sold Product'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: quantityController,
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
                controller: sellPriceController,
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
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                if (quantityController.text.isNotEmpty && sellPriceController.text.isNotEmpty) {
                  setState(() {
                    soldProduct.quantity = int.parse(quantityController.text);
                    soldProduct.sellPrice = double.parse(sellPriceController.text);
                  });
                  Navigator.pop(context);
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}