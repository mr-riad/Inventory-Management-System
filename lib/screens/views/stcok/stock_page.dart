import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/product_provider.dart';
import '../../../utils/colors.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    // Sorting to move low stock items to the top
    List products = List.from(productProvider.filteredProducts.isEmpty
        ? productProvider.products
        : productProvider.filteredProducts)
      ..sort((a, b) => a.stock < 5 ? -1 : 1); // Move low stock items up

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text("Stock"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                bool isLowStock = product.stock < 5; // Define low stock threshold
                return Container(
                  margin: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: isLowStock ? Colors.red : AppColors.textSecondary,
                      width: isLowStock ? 2 : 1,
                    ),
                    color: isLowStock ? Colors.red.withOpacity(0.1) : null,
                  ),
                  child: ListTile(
                    title: Text(
                      product.name,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: isLowStock ? Colors.red : Colors.black,
                      ),
                    ),
                    subtitle: Text(
                      'Stock: ${product.stock}',
                      style: TextStyle(
                        color: isLowStock ? Colors.red : Colors.black54,
                      ),
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
}
