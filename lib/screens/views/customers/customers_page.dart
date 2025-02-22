import 'package:flutter/material.dart';
import 'package:invetory_management1/utils/colors.dart';
import 'package:provider/provider.dart';

import '../../../providers/product_provider.dart';
import '../../../providers/sale_provider.dart';

class CustomersPage extends StatefulWidget {
  const CustomersPage({super.key});

  @override
  State<CustomersPage> createState() => _CustomersPageState();
}

class _CustomersPageState extends State<CustomersPage> {
  @override
  Widget build(BuildContext context) {
    final saleProvider = Provider.of<SaleProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Customers', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: saleProvider.sales.length,
          itemBuilder: (context, index) {
            final sale = saleProvider.sales[index];
            final product = productProvider.products.firstWhere(
                  (p) => p.id == sale.productId,
            );

            return Card(
              elevation: 4,
              margin: const EdgeInsets.only(bottom: 16), // Add margin between cards
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      sale.customerName,
                      style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Email: ${sale.customerEmail}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Phone: ${sale.customerPhone}',
                      style: const TextStyle(fontSize: 14, color: Colors.grey),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.bottomRight,
                      child: IconButton(
                        icon: const Icon(Icons.delete_forever, color: Colors.red),
                        onPressed: () {
                          saleProvider.deleteSale(sale.id);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}