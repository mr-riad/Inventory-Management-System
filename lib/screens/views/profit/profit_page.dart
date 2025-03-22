import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:invetory_management1/providers/sale_provider.dart';
import 'package:invetory_management1/utils/colors.dart';

class TotalProfitPage extends StatefulWidget {
  @override
  _TotalProfitPageState createState() => _TotalProfitPageState();
}

class _TotalProfitPageState extends State<TotalProfitPage> {
  String _selectedFilter = 'Lifetime'; // Default filter
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    final saleProvider = Provider.of<SaleProvider>(context);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Text('Total Profit', style: TextStyle(color: Colors.white)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildFilterButton('Lifetime'),
                _buildFilterButton('Day'),
                _buildFilterButton('Month'),
                _buildFilterButton('Year'),
              ],
            ),
          ),
          if (_selectedFilter != 'Lifetime')
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: ElevatedButton(
                onPressed: () async {
                  final DateTime? pickedDate = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (pickedDate != null) {
                    setState(() {
                      _selectedDate = pickedDate;
                    });
                  }
                },
                child: Text(
                  _selectedDate == null
                      ? 'Select Date'
                      : 'Selected: ${_selectedDate!.toLocal().toString().split(' ')[0]}',
                ),
              ),
            ),
          Expanded(
            child: Center(
              child: Text(
                'Total Profit: ${_getProfit(context, saleProvider).toStringAsFixed(2)}৳',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterButton(String filter) {
    return ElevatedButton(
      onPressed: () {
        setState(() {
          _selectedFilter = filter;
          _selectedDate = null; // Reset date when filter changes
        });
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: _selectedFilter == filter ? AppColors.primary : Colors.grey,
      ),
      child: Text(filter),
    );
  }

  double _getProfit(BuildContext context, SaleProvider saleProvider) {
    switch (_selectedFilter) {
      case 'Day':
        return saleProvider.calculateDailyProfit(context, _selectedDate ?? DateTime.now());
      case 'Month':
        return saleProvider.calculateMonthlyProfit(context, _selectedDate ?? DateTime.now());
      case 'Year':
        return saleProvider.calculateYearlyProfit(context, _selectedDate ?? DateTime.now());
      case 'Lifetime':
      default:
        return saleProvider.calculateLifetimeProfit(context);
    }
  }
}