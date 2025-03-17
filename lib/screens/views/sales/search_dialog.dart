// import 'package:flutter/material.dart';
// import 'package:invetory_management1/models/sale_model.dart';
// import 'package:invetory_management1/providers/product_provider.dart';
// import 'package:invetory_management1/providers/sale_provider.dart';
//
// class SaleSearchDelegate extends SearchDelegate<String> {
//   final SaleProvider saleProvider;
//   final ProductProvider productProvider;
//
//   SaleSearchDelegate(this.saleProvider, this.productProvider);
//
//   @override
//   List<Widget> buildActions(BuildContext context) {
//     return [
//       IconButton(
//         icon: const Icon(Icons.clear),
//         onPressed: () {
//           query = ''; // Clear the search query
//         },
//       ),
//     ];
//   }
//
//   @override
//   Widget buildLeading(BuildContext context) {
//     return IconButton(
//       icon: const Icon(Icons.arrow_back),
//       onPressed: () {
//         close(context, ''); // Close the search delegate
//       },
//     );
//   }
//
//   @override
//   Widget buildResults(BuildContext context) {
//     return _buildSearchResults();
//   }
//
//   @override
//   Widget buildSuggestions(BuildContext context) {
//     return _buildSearchResults();
//   }
//
//   Widget _buildSearchResults() {
//     // Filter sales based on the search query
//     final filteredSales = saleProvider.sales.where((sale) {
//       // Check if any sold product matches the query
//       final productMatches = sale.soldProducts.any((soldProduct) {
//         final product = productProvider.products.firstWhere(
//               (p) => p.id == soldProduct.productId,
//           orElse: () => throw Exception('Product not found'),
//         );
//         return product.name.toLowerCase().contains(query.toLowerCase());
//       });
//
//       // Check if customer details match the query
//       final customerMatches = sale.customerName.toLowerCase().contains(query.toLowerCase()) ||
//           sale.customerEmail.toLowerCase().contains(query.toLowerCase()) ||
//           sale.customerPhone.toLowerCase().contains(query.toLowerCase());
//
//       return productMatches || customerMatches;
//     }).toList();
//
//     return ListView.builder(
//       itemCount: filteredSales.length,
//       itemBuilder: (context, index) {
//         final sale = filteredSales[index];
//         return Card(
//           margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
//           child: ListTile(
//             title: Text(sale.customerName),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Email: ${sale.customerEmail}'),
//                 Text('Phone: ${sale.customerPhone}'),
//                 const SizedBox(height: 8),
//                 ...sale.soldProducts.map((soldProduct) {
//                   final product = productProvider.products.firstWhere(
//                         (p) => p.id == soldProduct.productId,
//                   );
//                   return Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       Text('Product: ${product.name}'),
//                       Text('Quantity: ${soldProduct.quantity}'),
//                       Text('Price: \$${soldProduct.sellPrice.toStringAsFixed(2)}'),
//                       const SizedBox(height: 4),
//                     ],
//                   );
//                 }).toList(),
//                 const SizedBox(height: 8),
//                 Text('Total Price: \$${sale.totalPrice.toStringAsFixed(2)}'),
//                 Text('Pay Amount: \$${sale.payAmount.toStringAsFixed(2)}'),
//                 Text('Borrow Amount: \$${sale.borrowAmount.toStringAsFixed(2)}'),
//               ],
//             ),
//             trailing: IconButton(
//               icon: const Icon(Icons.delete_forever, color: Colors.red),
//               onPressed: () {
//                 // Delete the sale
//                 saleProvider.deleteSale(sale.id);
//                 // Refresh the search results
//                 showResults(context);
//               },
//             ),
//           ),
//         );
//       },
//     );
//   }
// }