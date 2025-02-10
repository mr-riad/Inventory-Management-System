
// Custom Search Delegate for advanced search
import 'package:flutter/material.dart';

import '../../../providers/product_provider.dart';
import '../../../providers/sale_provider.dart';

class SaleSearchDelegate extends SearchDelegate<String> {
  final SaleProvider saleProvider;
  final ProductProvider productProvider;

  SaleSearchDelegate(this.saleProvider, this.productProvider);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        // Close the search delegate and return an empty string
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return _buildSearchResults();
  }

  Widget _buildSearchResults() {
    final filteredSales = saleProvider.sales.where((sale) {
      final product = productProvider.products.firstWhere(
            (p) => p.id == sale.productId,
      );
      return sale.customerName.toLowerCase().contains(query.toLowerCase()) ||
          sale.customerEmail.toLowerCase().contains(query.toLowerCase()) ||
          sale.customerPhone.toLowerCase().contains(query.toLowerCase()) ||
          product.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return ListView.builder(
      itemCount: filteredSales.length,
      itemBuilder: (context, index) {
        final sale = filteredSales[index];
        final product = productProvider.products.firstWhere(
              (p) => p.id == sale.productId,
        );

        return ListTile(
          title: Text(product.name),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Customer: ${sale.customerName}'),
              Text('Email: ${sale.customerEmail}'),
              Text('Phone: ${sale.customerPhone}'),
              Text('Quantity: ${sale.quantity}'),
              Text('Sell Price: \$${sale.sellPrice.toStringAsFixed(2)}'),
              Text('Total Price: \$${sale.totalPrice.toStringAsFixed(2)}'),
              Text('Pay Amount: \$${sale.payAmount.toStringAsFixed(2)}'),
              Text('Borrow Amount: \$${sale.borrowAmount.toStringAsFixed(2)}'),
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
    );
  }
}