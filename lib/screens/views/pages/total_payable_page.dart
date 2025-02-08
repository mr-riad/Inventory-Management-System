import 'package:flutter/material.dart';

class TotalPayablePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Total Payable Amount'),
      ),
      body: Center(
        child: Text(
          'Total Payable Amount: \$10,000', // Replace with actual data
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}