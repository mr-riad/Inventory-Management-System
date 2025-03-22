import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:provider/provider.dart';
import '../../../models/sale_model.dart';
import '../../../providers/sale_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class BorrowPage extends StatefulWidget {
  const BorrowPage({super.key});

  @override
  State<BorrowPage> createState() => _BorrowPageState();
}

class _BorrowPageState extends State<BorrowPage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    Provider.of<SaleProvider>(context, listen: false).fetchSales();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final saleProvider = Provider.of<SaleProvider>(context);
    final aggregatedSales = saleProvider.getAggregatedSales();

    // Search filter
    final filteredSales = aggregatedSales.entries.where((entry) {
      return entry.key.toLowerCase().contains(_searchQuery.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Due'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Search by Customer Name',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {
                      _searchQuery = '';
                    });
                  },
                ),
              ),
              onChanged: (value) {
                setState(() {
                  _searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredSales.length,
              itemBuilder: (context, index) {
                final entry = filteredSales[index];
                final customerName = entry.key;
                final sales = entry.value;

                double totalBorrowAmount = sales.fold(0, (sum, sale) => sum + sale.borrowAmount);
                double totalPayAmount = sales.fold(0, (sum, sale) => sum + sale.payAmount);

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ExpansionTile(
                    title: Text(customerName),
                    subtitle: Text('Total Due Amount: ${totalBorrowAmount.toStringAsFixed(2)}'),
                    children: [
                      ListTile(
                        title: Text('Total Due Amount: ${totalBorrowAmount.toStringAsFixed(2)}'),
                        trailing: IconButton(
                          icon: const Icon(Icons.payment),
                          onPressed: () {
                            _recordTotalPayment(context, customerName, totalBorrowAmount, sales);
                          },
                        ),
                      ),
                      ...sales.map((sale) {
                        return ListTile(
                          title: Text('Sale Date: ${sale.saleDate.toString()}'),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Due Amount: ${sale.borrowAmount.toStringAsFixed(2)}'),
                              Text('Last Paid Amount: ${sale.payAmount.toStringAsFixed(2)}'),
                            ],
                          ),
                        );
                      }).toList(),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _recordTotalPayment(BuildContext context, String customerName, double totalDueAmount, List<Sale> sales) {
    final TextEditingController _paymentAmountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Record Total Payment'),
          content: TextField(
            controller: _paymentAmountController,
            decoration: const InputDecoration(
              labelText: 'Payment Amount',
            ),
            keyboardType: TextInputType.number,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                final paymentAmount = double.tryParse(_paymentAmountController.text) ?? 0.0;
                if (paymentAmount <= totalDueAmount) {
                  for (var sale in sales) {
                    Provider.of<SaleProvider>(context, listen: false)
                        .addPaymentRecord(sale.id, paymentAmount / sales.length, DateTime.now());
                  }
                  Navigator.of(context).pop();
                  _printTotalPaymentBill(customerName, totalDueAmount, paymentAmount);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Payment amount cannot exceed total due amount')),
                  );
                }
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _printTotalPaymentBill(String customerName, double totalDueAmount, double paymentAmount) async {
    final pdf = pw.Document();

    final remainingBalance = totalDueAmount - paymentAmount;

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Text('Customer Bill', style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 20),
              pw.Text('Customer Name: $customerName'),
              pw.SizedBox(height: 20),
              pw.Text('Total Due Amount: ${totalDueAmount.toStringAsFixed(2)}'),
              pw.Text('Payment Amount: ${paymentAmount.toStringAsFixed(2)}'),
              pw.Text('Remaining Balance: ${remainingBalance.toStringAsFixed(2)}'),
              pw.SizedBox(height: 20),
              pw.Text('Payment Date: ${DateTime.now().toString()}'),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}