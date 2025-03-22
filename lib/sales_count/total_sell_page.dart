import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:invetory_management1/providers/sale_provider.dart';
import 'package:invetory_management1/utils/colors.dart';

class TotalSellPage extends StatefulWidget {
  const TotalSellPage({super.key});

  @override
  State<TotalSellPage> createState() => _TotalSellPageState();
}

class _TotalSellPageState extends State<TotalSellPage> {
  String _selectedFilter = 'Lifetime'; // Default filter
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    final saleProvider = Provider.of<SaleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: const Text('Total Products Sold', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFilterButton('Day'),
                _buildFilterButton('Month'),
                _buildFilterButton('Year'),
                _buildFilterButton('Lifetime'),
              ],
            ),
          ),
          if (_selectedFilter != 'Lifetime')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () => _selectDate(context),
                      child: Text(
                        _selectedDate == null
                            ? 'Select Date'
                            : 'Selected: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
                        style: TextStyle(color: AppColors.primary),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(
            child: Center(
              child: FutureBuilder<int>(
                future: _getTotalProductsSold(saleProvider),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    return Text(
                      'Total Products Sold: ${snapshot.data}',
                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String filter) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedFilter == filter ? AppColors.primary : Colors.grey,
      ),
      onPressed: () {
        setState(() {
          _selectedFilter = filter;
          if (filter == 'Lifetime') {
            _selectedDate = null;
          }
        });
      },
      child: Text(filter, style: TextStyle(color: Colors.white)),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<int> _getTotalProductsSold(SaleProvider saleProvider) async {
    int totalProductsSold = 0;

    switch (_selectedFilter) {
      case 'Day':
        if (_selectedDate != null) {
          totalProductsSold = saleProvider.sales
              .where((sale) =>
          sale.saleDate.year == _selectedDate!.year &&
              sale.saleDate.month == _selectedDate!.month &&
              sale.saleDate.day == _selectedDate!.day)
              .fold(0, (sum, sale) => sum + sale.soldProducts.fold(0, (sum, product) => sum + product.quantity));
        }
        break;
      case 'Month':
        if (_selectedDate != null) {
          totalProductsSold = saleProvider.sales
              .where((sale) =>
          sale.saleDate.year == _selectedDate!.year &&
              sale.saleDate.month == _selectedDate!.month)
              .fold(0, (sum, sale) => sum + sale.soldProducts.fold(0, (sum, product) => sum + product.quantity));
        }
        break;
      case 'Year':
        if (_selectedDate != null) {
          totalProductsSold = saleProvider.sales
              .where((sale) => sale.saleDate.year == _selectedDate!.year)
              .fold(0, (sum, sale) => sum + sale.soldProducts.fold(0, (sum, product) => sum + product.quantity));
        }
        break;
      case 'Lifetime':
        totalProductsSold = saleProvider.sales
            .fold(0, (sum, sale) => sum + sale.soldProducts.fold(0, (sum, product) => sum + product.quantity));
        break;
    }

    return totalProductsSold;
  }
}