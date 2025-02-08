import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/product_provider.dart';
import '../../../providers/sale_provider.dart';

class ProfitPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final saleProvider = Provider.of<SaleProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    // Calculate total revenue based on the sell price
    double totalRevenue = saleProvider.sales.fold(0, (sum, sale) => sum + sale.totalPrice);

    // Calculate total cost based on the buy price
    double totalCost = saleProvider.sales.fold(0, (sum, sale) {
      final product = productProvider.products.firstWhere((p) => p.id == sale.productId);
      return sum + (product.buyPrice * sale.quantity); // Use buyPrice instead of sell price
    });

    // Calculate profit
    double profit = totalRevenue - totalCost;

    return Scaffold(
      appBar: AppBar(
        title: Text('Profit Calculation'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Total Revenue: \$${totalRevenue.toStringAsFixed(2)}'),
            Text('Total Cost: \$${totalCost.toStringAsFixed(2)}'),
            Text('Profit: \$${profit.toStringAsFixed(2)}'),
          ],
        ),
      ),
    );
  }
}