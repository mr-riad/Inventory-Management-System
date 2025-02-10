import 'package:flutter/material.dart';
import 'package:invetory_management1/screens/views/product/edit_product_page.dart';
import 'package:provider/provider.dart';
import '../../../providers/product_provider.dart';
import 'add_product_page.dart';

class ProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<ProductProvider>(context);

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (query) {
            productProvider.searchProducts(query);
          },
          decoration: InputDecoration(
            hintText: 'Search products...',
            border: InputBorder.none,
          ),
        ),
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
                  subtitle: Text(
                      'Stock: ${product.stock}, Price: ${product.buyPrice.toStringAsFixed(2)} \৳'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit),
                        onPressed: () {
                          // Navigate to edit product page
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  EditProductPage(product: product),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () {
                          productProvider.deleteProduct(product.id);
                        },
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to add product page
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProductPage(),
            ),
          );
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
