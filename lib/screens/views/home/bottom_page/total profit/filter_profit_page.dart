import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../../providers/product_provider.dart';
import '../../../../../providers/sale_provider.dart';
class FilteredProfitPage extends StatelessWidget {
  final int selectedMonth;
  final int selectedYear;

  FilteredProfitPage({required this.selectedMonth, required this.selectedYear});

  @override
  Widget build(BuildContext context) {
    final saleProvider = Provider.of<SaleProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    // Filter sales by month and year
    final filteredSales = saleProvider.sales.where((sale) {
      return sale.saleDate.month == selectedMonth && sale.saleDate.year == selectedYear;
    }).toList();

    // Calculate total profit for filtered sales
    double totalProfit = 0;
    for (var sale in filteredSales) {
      try {
        final product = productProvider.products.firstWhere(
              (p) => p.id == sale.productId,
        );
        final profit = (sale.sellPrice - product.buyPrice) * sale.quantity;
        totalProfit += profit;
      } catch (e) {
        // Skip if product is not found
        continue;
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Profit for $selectedMonth/$selectedYear'),
      ),
      body: Center(
        child: Text(
          'Total Profit: ${totalProfit.toStringAsFixed(2)} ৳',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: totalProfit >= 0 ? Colors.green : Colors.red,
          ),
        ),
      ),
    );
  }
}