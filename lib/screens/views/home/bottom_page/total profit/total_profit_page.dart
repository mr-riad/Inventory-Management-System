// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../../../providers/product_provider.dart';
// import '../../../../../providers/sale_provider.dart';
//
// class TotalProfitPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final saleProvider = Provider.of<SaleProvider>(context);
//     final productProvider = Provider.of<ProductProvider>(context);
//
//     // Calculate total profit
//     double totalProfit = 0;
//     for (var sale in saleProvider.sales) {
//       try {
//         final product = productProvider.products.firstWhere(
//               (p) => p.id == sale.productId,
//         );
//         final profit = (sale.sellPrice - product.buyPrice) * sale.quantity;
//         totalProfit += profit;
//       } catch (e) {
//         // Skip if product is not found
//         continue;
//       }
//     }
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Total Profit'),
//       ),
//       body: Center(
//         child: Text(
//           'Total Profit: ${totalProfit.toStringAsFixed(2)} ৳',
//           style: TextStyle(
//             fontSize: 24,
//             fontWeight: FontWeight.bold,
//             color: totalProfit >= 0 ? Colors.green : Colors.red,
//           ),
//         ),
//       ),
//     );
//   }
// }