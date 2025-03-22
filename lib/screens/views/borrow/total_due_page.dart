import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../providers/sale_provider.dart';

class TotalDuePage extends StatefulWidget {
  const TotalDuePage({super.key});

  @override
  State<TotalDuePage> createState() => _TotalDuePageState();
}

class _TotalDuePageState extends State<TotalDuePage> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  DateTime? _selectedDate;
  String? _selectedMonth;
  bool _showLifetime = false;

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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _selectedMonth = null; // Reset month filter when date is selected
      });
    }
  }

  void _selectMonth(BuildContext context) {
    final List<String> months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Select Month'),
          content: SizedBox(
            width: double.maxFinite,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: months.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(months[index]),
                  onTap: () {
                    setState(() {
                      _selectedMonth = months[index];
                      _selectedDate = null; // Reset date filter when month is selected
                    });
                    Navigator.of(context).pop();
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  void _toggleLifetime() {
    setState(() {
      _showLifetime = !_showLifetime;
      _selectedDate = null; // Reset date filter
      _selectedMonth = null; // Reset month filter
    });
  }

  @override
  Widget build(BuildContext context) {
    final saleProvider = Provider.of<SaleProvider>(context);
    final aggregatedSales = saleProvider.getAggregatedSales();

    // Filter sales based on date, month, or lifetime
    final filteredSales = aggregatedSales.entries.where((entry) {
      final sales = entry.value;

      if (_selectedDate != null) {
        return sales.any((sale) =>
        sale.saleDate.year == _selectedDate!.year &&
            sale.saleDate.month == _selectedDate!.month &&
            sale.saleDate.day == _selectedDate!.day);
      } else if (_selectedMonth != null) {
        return sales.any((sale) =>
        DateFormat('MMMM').format(sale.saleDate) == _selectedMonth);
      } else if (_showLifetime) {
        return true; // Show all sales for lifetime
      } else {
        return entry.key.toLowerCase().contains(_searchQuery.toLowerCase());
      }
    }).toList();

    // Calculate total borrow amount for all customers
    double totalBorrowAmount = filteredSales.fold(0, (sum, entry) {
      return sum + entry.value.fold(0, (sum, sale) => sum + sale.borrowAmount);
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Total Borrow Amount'),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
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
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                      onPressed: () => _selectDate(context),
                      child: const Text('Filter by Date'),
                    ),
                    ElevatedButton(
                      onPressed: () => _selectMonth(context),
                      child: const Text('Filter by Month'),
                    ),
                    ElevatedButton(
                      onPressed: _toggleLifetime,
                      child: Text(_showLifetime ? 'Hide Lifetime' : 'Show Lifetime'),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredSales.length,
              itemBuilder: (context, index) {
                final entry = filteredSales[index];
                final customerName = entry.key;
                final sales = entry.value;

                double customerBorrowAmount = sales.fold(0, (sum, sale) => sum + sale.borrowAmount);

                return Card(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: ListTile(
                    title: Text(customerName),
                    subtitle: Text('Total Borrow Amount: ${customerBorrowAmount.toStringAsFixed(2)}'),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Total Borrow Amount for All Customers: ${totalBorrowAmount.toStringAsFixed(2)}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}