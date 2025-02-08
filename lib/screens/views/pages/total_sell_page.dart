import 'package:flutter/material.dart';

class TotalSellPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Total Sell'),
      ),
      body: Center(
        child: Text(
          'Total Sell: \$50,000', // Replace with actual data
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}