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
    final screenWidth = MediaQuery.of(context).size.width;

    // Sorting to move low stock items to the top
    List products = List.from(productProvider.filteredProducts.isEmpty
        ? productProvider.products
        : productProvider.filteredProducts)
      ..sort((a, b) => a.stock < 5 ? -1 : 1); // Move low stock items up

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text("Stock"),
        centerTitle: true,
        elevation: 10,
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: products.length,
                itemBuilder: (context, index) {
                  final product = products[index];
                  bool isLowStock = product.stock < 5; // Define low stock threshold
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(vertical: 5),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: isLowStock ? Colors.red.withOpacity(0.1) : Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 5),
                        ),
                      ],
                      border: Border.all(
                        color: isLowStock ? Colors.red : AppColors.textSecondary,
                        width: isLowStock ? 2 : 1,
                      ),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      title: Text(
                        product.name,
                        style: TextStyle(
                          fontSize: screenWidth * 0.05, // Responsive font size
                          fontWeight: FontWeight.bold,
                          color: isLowStock ? Colors.red : Colors.black,
                        ),
                      ),
                      subtitle: Text(
                        'Stock: ${product.stock}',
                        style: TextStyle(
                          fontSize: screenWidth * 0.04, // Responsive font size
                          color: isLowStock ? Colors.red : Colors.black54,
                        ),
                      ),
                      trailing: Icon(
                        Icons.arrow_forward_ios,
                        color: isLowStock ? Colors.red : AppColors.primary,
                      ),
                      onTap: () {
                        // Handle product tap
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}