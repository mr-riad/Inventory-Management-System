import 'package:flutter/material.dart';
import 'package:invetory_management1/screens/views/sales/search_dialog.dart';
import 'package:invetory_management1/utils/colors.dart';
import 'package:provider/provider.dart';

import '../../../providers/product_provider.dart';
import '../../../providers/sale_provider.dart';
import 'add_sale_page.dart';
import 'edit_sale_page.dart';

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

    // Get screen size
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Responsive font sizes
    final titleFontSize = screenWidth * 0.06; // 6% of screen width
    final infoFontSize = screenWidth * 0.04; // 4% of screen width

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text(
          'Sales',
          style: TextStyle(
            color: AppColors.textOnPrimary,
            fontWeight: FontWeight.bold,
            fontSize: titleFontSize,
          ),
        ),
        actions: [
          IconButton(
            color: AppColors.textOnPrimary,
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(
                context: context,
                delegate: SaleSearchDelegate(saleProvider, productProvider),
              );
            },
          ),
        ],
      ),
      body: saleProvider.sales.isEmpty
          ? Center(
        child: Text(
          'No sales found',
          style: TextStyle(
            fontSize: infoFontSize,
            color: Colors.grey,
          ),
        ),
      )
          : LayoutBuilder(
        builder: (context, constraints) {
          // Use a grid for larger screens, list for smaller screens
          if (constraints.maxWidth > 600) {
            return _buildGridLayout(
                saleProvider, productProvider, infoFontSize);
          } else {
            return _buildListLayout(
                saleProvider, productProvider, infoFontSize);
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddSalePage(),
            ),
          );
        },
        child: const Icon(Icons.add, color: AppColors.textOnPrimary),
      ),
    );
  }

  Widget _buildListLayout(SaleProvider saleProvider,
      ProductProvider productProvider, double infoFontSize) {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: saleProvider.sales.length,
      itemBuilder: (context, index) {
        final sale = saleProvider.sales[index];
        final product = productProvider.products.firstWhere(
              (p) => p.id == sale.productId,
        );

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.only(bottom: 16),
          child: ListTile(
            contentPadding: const EdgeInsets.all(16),
            title: Text(
              product.name,
              style: TextStyle(
                fontSize: infoFontSize * 1.2,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 8),
                _buildInfoRow(Icons.person, sale.customerName, infoFontSize),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.email, sale.customerEmail, infoFontSize),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.phone, sale.customerPhone, infoFontSize),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.shopping_cart, 'Quantity: ${sale.quantity}',
                    infoFontSize),
                const SizedBox(height: 8),
                _buildInfoRow(
                    Icons.attach_money,
                    'Sell Price: ${sale.sellPrice.toStringAsFixed(2)}\৳',
                    infoFontSize),
                const SizedBox(height: 8),
                _buildInfoRow(
                    Icons.money,
                    'Total Price: ${sale.totalPrice.toStringAsFixed(2)}\৳',
                    infoFontSize),
                const SizedBox(height: 8),
                _buildInfoRow(
                    Icons.payment,
                    'Pay Amount: ${sale.payAmount.toStringAsFixed(2)}\৳',
                    infoFontSize),
                const SizedBox(height: 8),
                _buildInfoRow(
                    Icons.money_off,
                    'Borrow Amount: ${sale.borrowAmount.toStringAsFixed(2)}\৳',
                    infoFontSize),
              ],
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit, color: Colors.blue),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditSalePage(sale: sale),
                      ),
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.delete_forever, color: Colors.red),
                  onPressed: () {
                    saleProvider.deleteSale(sale.id);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGridLayout(SaleProvider saleProvider,
      ProductProvider productProvider, double infoFontSize) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // 2 columns for larger screens
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.5, // Adjust aspect ratio as needed
      ),
      itemCount: saleProvider.sales.length,
      itemBuilder: (context, index) {
        final sale = saleProvider.sales[index];
        final product = productProvider.products.firstWhere(
              (p) => p.id == sale.productId,
        );

        return Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: TextStyle(
                    fontSize: infoFontSize * 1.2,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.person, sale.customerName, infoFontSize),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.email, sale.customerEmail, infoFontSize),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.phone, sale.customerPhone, infoFontSize),
                const SizedBox(height: 8),
                _buildInfoRow(Icons.shopping_cart, 'Quantity: ${sale.quantity}',
                    infoFontSize),
                const SizedBox(height: 8),
                _buildInfoRow(
                    Icons.attach_money,
                    'Sell Price: ${sale.sellPrice.toStringAsFixed(2)}\৳',
                    infoFontSize),
                const SizedBox(height: 8),
                _buildInfoRow(
                    Icons.money,
                    'Total Price: ${sale.totalPrice.toStringAsFixed(2)}\৳',
                    infoFontSize),
                const SizedBox(height: 8),
                _buildInfoRow(
                    Icons.payment,
                    'Pay Amount: ${sale.payAmount.toStringAsFixed(2)}\৳',
                    infoFontSize),
                const SizedBox(height: 8),
                _buildInfoRow(
                    Icons.money_off,
                    'Borrow Amount: ${sale.borrowAmount.toStringAsFixed(2)}\৳',
                    infoFontSize),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String text, double fontSize) {
    return Row(
      children: [
        Icon(icon, size: fontSize, color: Colors.grey),
        const SizedBox(width: 8),
        Text(
          text,
          style: TextStyle(fontSize: fontSize),
        ),
      ],
    );
  }
}
