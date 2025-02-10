import 'package:flutter/material.dart';
import 'package:invetory_management1/screens/views/sales/search_dialog.dart';
import 'package:provider/provider.dart';

import '../../../providers/product_provider.dart';
import '../../../providers/sale_provider.dart';
import 'add_sale_page.dart';

class SalePage extends StatefulWidget {
  const SalePage({super.key});

  @override
  State<SalePage> createState() => _SalePageState();
}

class _SalePageState extends State<SalePage> {
  @override
  Widget build(BuildContext context) {
    final saleProvider = Provider.of<SaleProvider>(context);
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Sales'),
        actions: [
          // Search icon in the AppBar
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Open the SaleSearchDelegate
              showSearch(
                context: context,
                delegate: SaleSearchDelegate(saleProvider, productProvider),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: saleProvider.sales.length,
        itemBuilder: (context, index) {
          final sale = saleProvider.sales[index];
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
                Text('Sell Price: ${sale.sellPrice.toStringAsFixed(2)}\৳'),
                Text('Total Price: ${sale.totalPrice.toStringAsFixed(2)}\৳'),
                Text('Pay Amount: ${sale.payAmount.toStringAsFixed(2)}\৳'),
                Text('Borrow Amount: ${sale.borrowAmount.toStringAsFixed(2)}\৳'),
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddSalePage(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}











// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import '../../../providers/product_provider.dart';
// import '../../../providers/sale_provider.dart';
// import 'add_sale_page.dart';
//
// class SalePage extends StatefulWidget {
//   const SalePage({super.key});
//
//   @override
//   State<SalePage> createState() => _SalePageState();
// }
//
// class _SalePageState extends State<SalePage> {
//   @override
//   Widget build(BuildContext context) {
//     final saleProvider = Provider.of<SaleProvider>(context);
//     final productProvider = Provider.of<ProductProvider>(context);
//
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Sales'),
//       ),
//       body: ListView.builder(
//         itemCount: saleProvider.sales.length,
//         itemBuilder: (context, index) {
//           final sale = saleProvider.sales[index];
//           final product = productProvider.products.firstWhere(
//                 (p) => p.id == sale.productId,
//           );
//
//           return ListTile(
//             title: Text(product.name),
//             subtitle: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text('Customer: ${sale.customerName}'),
//                 Text('Email: ${sale.customerEmail}'),
//                 Text('Phone: ${sale.customerPhone}'),
//                 Text('Quantity: ${sale.quantity}'),
//                 Text('Sell Price: \$${sale.sellPrice.toStringAsFixed(2)}'),
//                 Text('Total Price: \$${sale.totalPrice.toStringAsFixed(2)}'),
//                 Text('Pay Amount: \$${sale.payAmount.toStringAsFixed(2)}'),
//                 Text('Borrow Amount: \$${sale.borrowAmount.toStringAsFixed(2)}'),
//               ],
//             ),
//             trailing: IconButton(
//               icon: const Icon(Icons.delete_forever),
//               onPressed: () {
//                 saleProvider.deleteSale(sale.id);
//               },
//             ),
//           );
//         },
//       ),
//       floatingActionButton: FloatingActionButton(
//         onPressed: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => const AddSalePage(),
//             ),
//           );
//         },
//         child: const Icon(Icons.add),
//       ),
//     );
//   }
// }