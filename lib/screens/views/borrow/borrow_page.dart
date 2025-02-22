import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/sale_model.dart';
import '../../../providers/product_provider.dart';
import '../../../providers/sale_provider.dart';

class BorrowPage extends StatefulWidget {
  const BorrowPage({super.key});

  @override
  State<BorrowPage> createState() => _BorrowPageState();
}

class _BorrowPageState extends State<BorrowPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final saleProvider = Provider.of<SaleProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    final filteredSales = saleProvider.sales.where((sale) {
      final matchesSearch = sale.customerName.toLowerCase().contains(_searchQuery.toLowerCase());
      final hasBorrowAmount = sale.borrowAmount > 0;
      return matchesSearch && hasBorrowAmount;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Borrow',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        elevation: 10,
        shadowColor: Colors.blueAccent.withOpacity(0.5),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 5,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search by Customer Name',
                  labelStyle: TextStyle(color: Colors.grey[600]),
                  prefixIcon: const Icon(Icons.search, color: Colors.blueAccent),
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear, color: Colors.blueAccent),
                    onPressed: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                      });
                    },
                  ),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                ),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value;
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredSales.length,
              itemBuilder: (context, index) {
                final sale = filteredSales[index];
                final product = productProvider.products.firstWhere(
                      (p) => p.id == sale.productId,
                );

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16),
                    title: Text(
                      sale.customerName,
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.blueAccent),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 8),
                        Text(
                          'Email: ${sale.customerEmail}',
                          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Phone: ${sale.customerPhone}',
                          style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Borrow Amount: ${sale.borrowAmount.toStringAsFixed(2)} \৳',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.red),
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit, color: Colors.blueAccent),
                          onPressed: () {
                            _editBorrowAmount(context, sale);
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete_forever, color: Colors.red),
                          onPressed: () {
                            saleProvider.deleteSale(sale.id);
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _editBorrowAmount(BuildContext context, Sale sale) {
    final TextEditingController _borrowAmountController = TextEditingController(text: sale.borrowAmount.toString());

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            'Edit Borrow Amount',
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.blueAccent),
          ),
          content: TextField(
            controller: _borrowAmountController,
            decoration: const InputDecoration(
              labelText: 'Borrow Amount',
              labelStyle: TextStyle(color: Colors.blueAccent),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Colors.blueAccent),
              ),
            ),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.grey),
              ),
            ),
            TextButton(
              onPressed: () {
                final newBorrowAmount = double.tryParse(_borrowAmountController.text) ?? 0.0;
                Provider.of<SaleProvider>(context, listen: false).updateBorrowAmount(sale.id, newBorrowAmount);
                Navigator.of(context).pop();
              },
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.blueAccent),
              ),
            ),
          ],
        );
      },
    );
  }
}