import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:invetory_management1/providers/sale_provider.dart';
import 'package:invetory_management1/screens/views/sales/add_sale_page.dart';
import 'package:invetory_management1/screens/views/sales/edit_sale_page.dart';
import 'package:invetory_management1/screens/views/sales/sales_report_page.dart';
import 'package:invetory_management1/utils/colors.dart';

class SalePage extends StatefulWidget {
  const SalePage({super.key});

  @override
  State<SalePage> createState() => _SalePageState();
}

class _SalePageState extends State<SalePage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final saleProvider = Provider.of<SaleProvider>(context, listen: false);
      saleProvider.fetchSales();
      saleProvider.fetchOldestCustomers();
    });
  }

  @override
  Widget build(BuildContext context) {
    final saleProvider = Provider.of<SaleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Sales', style: TextStyle(color: Colors.white)),
      ),
      body: saleProvider.isLoading
          ? const Center(child: CircularProgressIndicator())
          : saleProvider.sales.isEmpty
          ? const Center(
        child: Text('No sales found', style: TextStyle(color: Colors.grey)),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: saleProvider.sales.length,
        itemBuilder: (context, index) {
          final sale = saleProvider.sales[index];
          final totalBorrowAmount = saleProvider.getTotalBorrowAmountForCustomer(sale.customerName, 0.0); // Pass 0.0 as the second argument
          final previousDue = totalBorrowAmount - sale.borrowAmount;

          return Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.only(bottom: 16),
            child: ListTile(
              contentPadding: const EdgeInsets.all(16),
              title: Text(sale.customerName,
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 8),
                  _buildInfoRow(Icons.email, sale.customerEmail),
                  _buildInfoRow(Icons.phone, sale.customerPhone),
                  const SizedBox(height: 8),
                  Text(
                      'Total Price: ${sale.totalPrice.toStringAsFixed(2)}৳',
                      style: const TextStyle(fontWeight: FontWeight.bold)),
                  Text('Previous Due: ${previousDue.toStringAsFixed(2)}৳',
                      style: const TextStyle(color: Colors.orange)),
                  Text('Pay Amount: ${sale.payAmount.toStringAsFixed(2)}৳'),
                  Text(
                      'Borrow Amount: ${sale.borrowAmount.toStringAsFixed(2)}৳',
                      style: const TextStyle(color: Colors.red)),
                  Text(
                      'Total Borrow Amount: ${totalBorrowAmount.toStringAsFixed(2)}৳',
                      style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 8),
                  const Text('Sold Products:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: sale.soldProducts.map((product) {
                      return Text(
                          '- ${product.productName} (x${product.quantity})  @  ${product.sellPrice}৳');
                    }).toList(),
                  ),
                  const SizedBox(height: 8),
                  Text('Sale Date: ${sale.saleDate.toString()}'),
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
                            builder: (context) => EditSalePage(sale: sale)),
                      );
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_forever, color: Colors.red),
                    onPressed: () async {
                      await saleProvider.deleteSale(sale.id);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.print, color: Colors.green),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SaleReportPage(
                            sale: sale,
                            totalBorrowAmount: totalBorrowAmount,
                            previousDue: previousDue,
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddSalePage()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 18, color: Colors.grey),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }
}