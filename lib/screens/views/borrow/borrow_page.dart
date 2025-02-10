import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/product_provider.dart';
import '../../../providers/sale_provider.dart';

class BorrowPage extends StatefulWidget {
  const BorrowPage({super.key});

  @override
  State<BorrowPage> createState() => _BorrowPageState();
}

class _BorrowPageState extends State<BorrowPage> {
  @override
  Widget build(BuildContext context) {
    final saleProvider = Provider.of<SaleProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Borrow'),
      ),
      body: ListView.builder(
        itemCount: saleProvider.sales.length,
        itemBuilder: (context, index) {
          final sale = saleProvider.sales[index];
          final product = productProvider.products.firstWhere(
                (p) => p.id == sale.productId,
          );

          return ListTile(
            title: Text(sale.customerName,style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),

            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text('Customer: ${sale.customerName}'),
                Text('Email: ${sale.customerEmail}'),
                Text('Phone: ${sale.customerPhone}'),
                Text('Borrow Amount: ${sale.borrowAmount.toStringAsFixed(2)} \৳'),
              ],
            ),
            trailing: IconButton(
              icon: const Icon(Icons.delete_forever),
              onPressed: () {
                saleProvider.deleteSale(sale.id);
              },
            ),
          );
        },
      ),
    );
  }
}