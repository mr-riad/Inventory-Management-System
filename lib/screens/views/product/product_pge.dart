import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../providers/product_provider.dart';
import '../../../utils/colors.dart';
import 'add_product_page.dart';
import 'edit_product_page.dart';

class ProductsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: AppColors.buttonDisabled,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Container(
          decoration: BoxDecoration(
            color: AppColors.textOnPrimary,
            borderRadius: BorderRadius.circular(30),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: TextField(
            onChanged: (query) {
              Provider.of<ProductProvider>(context, listen: false)
                  .searchProducts(query);
            },
            decoration: InputDecoration(
              hintText: 'Search products...',
              icon: Icon(Icons.search_rounded, color: Colors.grey),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
      body: Consumer<ProductProvider>(
        builder: (context, productProvider, child) {
          final products = productProvider.filteredProducts.isEmpty
              ? productProvider.products
              : productProvider.filteredProducts;

          return products.isEmpty
              ? Center(child: Text("No products available"))
              : ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Container(
                margin: EdgeInsets.all(5),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: AppColors.textSecondary),
                ),
                child: ListTile(
                  title: Text(product.name,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                  subtitle: Text(
                      'Price: ${product.buyPrice.toStringAsFixed(2)} ৳, Stock: ${product.stock}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
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
                        icon: Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          productProvider.deleteProduct(product.id);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AddProductPage(),
            ),
          );
        },
        child: Icon(Icons.add),
        backgroundColor: AppColors.primary,
      ),
    );
  }
}
