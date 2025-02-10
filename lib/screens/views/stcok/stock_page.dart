import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../providers/product_provider.dart';

class StockPage extends StatefulWidget {
  const StockPage({super.key});

  @override
  State<StockPage> createState() => _StockPageState();
}

class _StockPageState extends State<StockPage> {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Stock"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: productProvider.filteredProducts.isEmpty
                  ? productProvider.products.length
                  : productProvider.filteredProducts.length,
              itemBuilder: (context, index) {
                final product = productProvider.filteredProducts.isEmpty
                    ? productProvider.products[index]
                    : productProvider.filteredProducts[index];
                return ListTile(
                  title: Text(product.name),
                  subtitle: Text('Stock: ${product.stock}'),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
