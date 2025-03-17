// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../../providers/product_provider.dart';
// import '../../../providers/sale_provider.dart';
// import '../../../utils/colors.dart';
// import '../../../models/product_model.dart'; // Import the Product model
//
// class ProfitPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final saleProvider = Provider.of<SaleProvider>(context);
//     final productProvider = Provider.of<ProductProvider>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: AppColors.primary,
//         title: const Text(
//           'Product Profit',
//           style: TextStyle(
//             color: AppColors.textOnPrimary,
//             fontWeight: FontWeight.bold,
//             fontSize: 24,
//           ),
//         ),
//       ),
//       body: ListView.builder(
//         padding: const EdgeInsets.all(16),
//         itemCount: saleProvider.sales.length,
//         itemBuilder: (context, index) {
//           final sale = saleProvider.sales[index];
//           Product? product;
//
//           try {
//             product = productProvider.products.firstWhere(
//                   (p) => p.id == sale.productId,
//             );
//           } catch (e) {
//             // If no product is found, product will remain null
//             product = null;
//           }
//
//           // Skip if product is not found
//           if (product == null) {
//             return const SizedBox.shrink(); // Skip this sale
//           }
//
//           // Calculate profit for this sale
//           final profit = (sale.sellPrice - product.buyPrice) * sale.quantity;
//
//           return Card(
//             elevation: 4,
//             margin: const EdgeInsets.only(bottom: 10),
//             child: ListTile(
//               title: Text(
//                 product.name,
//                 style: const TextStyle(
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//               subtitle: Text(
//                 'Quantity Sold: ${sale.quantity}\n'
//                     'Buy Price: ${product.buyPrice.toStringAsFixed(2)} ৳\n'
//                     'Sell Price: ${sale.sellPrice.toStringAsFixed(2)} ৳',
//               ),
//               trailing: Text(
//                 'Profit: ${profit.toStringAsFixed(2)} ৳',
//                 style: TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: profit >= 0 ? Colors.green : Colors.red,
//                 ),
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }
// }