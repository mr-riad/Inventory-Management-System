import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/sale_model.dart';
import '../../../providers/product_provider.dart';
import '../../../providers/sale_provider.dart';
import 'sales_report_page.dart';

class AddSalePage extends StatefulWidget {
  const AddSalePage({super.key});

  @override
  State<AddSalePage> createState() => _AddSalePageState();
}

class _AddSalePageState extends State<AddSalePage> {
  final _formKey = GlobalKey<FormState>();
  final _customerNameController = TextEditingController();
  final _customerEmailController = TextEditingController();
  final _customerPhoneController = TextEditingController();
  final _customerAddressController = TextEditingController();
  final _payAmountController = TextEditingController();
  final _searchController = TextEditingController();

  List<Map<String, dynamic>> _selectedProducts = [];
  Sale? _selectedCustomer;
  List<Sale> _searchResults = [];

  @override
  void initState() {
    super.initState();
    final saleProvider = Provider.of<SaleProvider>(context, listen: false);
    saleProvider.fetchSales();
  }

  void _addProduct(String productId, String productName, int quantity, double sellPrice, double buyPrice) {
    final productProvider = Provider.of<ProductProvider>(context, listen: false);
    final product = productProvider.products.firstWhere((p) => p.id == productId);

    if (product.stock == 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$productName is out of stock and cannot be sold.')),
      );
      return;
    }

    if (product.stock < quantity) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Not enough stock for $productName. Only ${product.stock} available.')),
      );
      return;
    }

    setState(() {
      _selectedProducts.add({
        'productId': productId,
        'productName': productName,
        'quantity': quantity,
        'sellPrice': sellPrice,
        'buyPrice': buyPrice,
      });
    });
  }

  void _removeProduct(int index) {
    setState(() {
      _selectedProducts.removeAt(index);
    });
  }

  double _calculateTotalPrice() {
    return _selectedProducts.fold(0.0, (sum, product) {
      return sum + (product['quantity'] * product['sellPrice']);
    });
  }

  void _searchCustomers(String query) {
    final saleProvider = Provider.of<SaleProvider>(context, listen: false);
    final allCustomers = saleProvider.searchCustomers(query);

    final uniqueCustomerNames = <String>{};
    final uniqueCustomers = <Sale>[];

    for (final customer in allCustomers) {
      if (!uniqueCustomerNames.contains(customer.customerName)) {
        uniqueCustomerNames.add(customer.customerName);
        uniqueCustomers.add(customer);
      }
    }

    setState(() {
      _searchResults = uniqueCustomers;
    });
  }

  void _selectCustomer(Sale customer) {
    setState(() {
      _selectedCustomer = customer;
      _customerNameController.text = customer.customerName;
      _customerEmailController.text = customer.customerEmail;
      _customerPhoneController.text = customer.customerPhone;
      _customerAddressController.text = customer.customerAddress ?? '';
      _searchController.clear();
      _searchResults.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final saleProvider = Provider.of<SaleProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Sale'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Customer search and selection
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _searchController,
                        decoration: InputDecoration(
                          labelText: 'Search Customer',
                          suffixIcon: IconButton(
                            icon: const Icon(Icons.search),
                            onPressed: () {
                              _searchCustomers(_searchController.text);
                            },
                          ),
                        ),
                        onChanged: (value) {
                          _searchCustomers(value);
                        },
                      ),
                      const SizedBox(height: 20),
                      if (_searchResults.isNotEmpty)
                        Column(
                          children: _searchResults.map((customer) {
                            final totalBorrowAmount = saleProvider.getTotalBorrowAmountForCustomer(customer.customerName, 0);
                            return ListTile(
                              title: Text(customer.customerName),
                              subtitle: Text('Total Borrow Amount: \৳${totalBorrowAmount.toStringAsFixed(2)}'),
                              onTap: () {
                                _selectCustomer(customer);
                              },
                            );
                          }).toList(),
                        ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Customer details
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      TextFormField(
                        controller: _customerNameController,
                        decoration: InputDecoration(labelText: 'Customer Name'),
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
                        decoration: InputDecoration(labelText: 'Customer Email'),
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
                        decoration: InputDecoration(labelText: 'Customer Phone'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter customer phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      TextFormField(
                        controller: _customerAddressController,
                        decoration: InputDecoration(labelText: 'Customer Address'),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter customer address';
                          }
                          return null;
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Selected products
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      ..._selectedProducts.asMap().entries.map((entry) {
                        final index = entry.key + 1;
                        final product = entry.value;
                        return ListTile(
                          leading: Text('$index.', style: TextStyle(fontSize: 16)),
                          title: Text(product['productName']),
                          subtitle: Text('Quantity: ${product['quantity']}, Price: \৳${product['sellPrice']}'),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () => _removeProduct(entry.key),
                          ),
                        );
                      }).toList(),
                      const SizedBox(height: 20),
                      Text(
                        'Total Price: \৳${_calculateTotalPrice().toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Add product button
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      String? selectedProductId;
                      final quantityController = TextEditingController();
                      final sellPriceController = TextEditingController();
                      double? buyPrice;

                      return AlertDialog(
                        title: const Text('Add Product'),
                        content: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            DropdownButtonFormField<String>(
                              value: selectedProductId,
                              items: productProvider.products.map((product) {
                                return DropdownMenuItem(
                                  value: product.id,
                                  child: Text('${product.name}  \৳${product.buyPrice.toStringAsFixed(2)}'),
                                );
                              }).toList(),
                              onChanged: (value) {
                                setState(() {
                                  selectedProductId = value;
                                  buyPrice = productProvider.products.firstWhere((p) => p.id == value).buyPrice;
                                });
                              },
                              decoration: InputDecoration(labelText: 'Product'),
                              hint: const Text('Select a product'),
                            ),
                            const SizedBox(height: 20),
                            TextFormField(
                              controller: quantityController,
                              decoration: InputDecoration(labelText: 'Quantity'),
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
                              controller: sellPriceController,
                              decoration: InputDecoration(labelText: 'Sell Price'),
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
                            if (buyPrice != null)
                              Text(
                                'Buy Price: \৳${buyPrice!.toStringAsFixed(2)}',
                                style: TextStyle(fontSize: 14, color: Colors.grey),
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
                              if (selectedProductId != null &&
                                  quantityController.text.isNotEmpty &&
                                  sellPriceController.text.isNotEmpty) {
                                final product = productProvider.products.firstWhere((p) => p.id == selectedProductId);
                                if (product.stock == 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('${product.name} is out of stock and cannot be sold.')),
                                  );
                                  return;
                                }
                                if (product.stock < int.parse(quantityController.text)) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Not enough stock for ${product.name}. Only ${product.stock} available.')),
                                  );
                                  return;
                                }
                                _addProduct(
                                  selectedProductId!,
                                  product.name,
                                  int.parse(quantityController.text),
                                  double.parse(sellPriceController.text),
                                  product.buyPrice,
                                );
                                Navigator.pop(context);
                              }
                            },
                            child: const Text('Add'),
                          ),
                        ],
                      );
                    },
                  );
                },
                child: const Text('Add Product'),
              ),
              const SizedBox(height: 20),

              // Pay amount
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: TextFormField(
                    controller: _payAmountController,
                    decoration: InputDecoration(labelText: 'Pay Amount'),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a pay amount';
                      }
                      if (double.tryParse(value) == null || double.parse(value) < 0) {
                        return 'Please enter a valid pay amount';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Add sale button
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    try {
                      final totalPrice = _calculateTotalPrice();
                      final payAmount = double.tryParse(_payAmountController.text) ?? 0.0;
                      final borrowAmount = totalPrice - payAmount;

                      // Calculate previous due and total borrow amount
                      final saleProvider = Provider.of<SaleProvider>(context, listen: false);
                      final previousDue = saleProvider.getPreviousDueForCustomer(_customerNameController.text);
                      final totalBorrowAmount = saleProvider.getTotalBorrowAmountForCustomer(_customerNameController.text, borrowAmount);

                      // Create the sale object
                      final sale = Sale(
                        id: '', // ID will be generated by Firestore
                        customerId: _selectedCustomer?.customerId ?? 'customerId',
                        customerName: _customerNameController.text,
                        customerEmail: _customerEmailController.text,
                        customerPhone: _customerPhoneController.text,
                        customerAddress: _customerAddressController.text,
                        soldProducts: _selectedProducts.map((product) {
                          return SoldProduct(
                            productId: product['productId'],
                            productName: product['productName'],
                            quantity: product['quantity'],
                            sellPrice: product['sellPrice'],
                          );
                        }).toList(),
                        totalPrice: totalPrice,
                        payAmount: payAmount,
                        borrowAmount: borrowAmount,
                        saleDate: DateTime.now(),
                        paymentHistory: [
                          {
                            'date': DateTime.now().toIso8601String(),
                            'amount': payAmount,
                            'type': 'payment',
                          },
                          {
                            'date': DateTime.now().toIso8601String(),
                            'amount': borrowAmount,
                            'type': 'borrow',
                          },
                        ],
                      );

                      // Add the sale and update the customer's borrow amount
                      saleProvider.addSale(sale, productProvider).then((_) {
                        // Navigate to the SalesReportPage with updated values
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SaleReportPage(
                              sale: sale,
                              previousDue: previousDue,
                              totalBorrowAmount: totalBorrowAmount,
                            ),
                          ),
                        );
                      });
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