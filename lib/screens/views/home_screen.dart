import 'package:flutter/material.dart';
import 'package:invetory_management1/screens/views/home_services/account_payable.dart';
import 'package:invetory_management1/screens/views/home_services/customers_page.dart';
import 'package:invetory_management1/screens/views/home_services/product_page.dart';
import 'package:invetory_management1/screens/views/home_services/sales_page.dart';

import 'home_services/profit_page.dart';
import 'home_services/stock_page.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Inventory Management'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProductsPage()));
              },
              child: Text('Manage Products'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => CustomersPage()));
              },
              child: Text('Manage Customers'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => SalesPage()));
              },
              child: Text('Manage Sales'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => AccountPayablePage()));
              },
              child: Text('Manage Account Payables'),
            ),
      ElevatedButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => StockPage()));
        },
        child: Text('Stock'),),
            ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => ProfitPage()));
              },
              child: Text('profit'),),
          ],
        ),
      ),
    );
  }
}