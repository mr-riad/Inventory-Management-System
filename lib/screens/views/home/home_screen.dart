import 'package:flutter/material.dart';
import 'package:invetory_management1/utils/colors.dart';
import '../../auth/login_screen.dart';
import '../borrow/borrow_page.dart';
import '../customers/customers_page.dart';
import '../product/product_pge.dart';
import '../sales/sale_page.dart';
import '../stcok/stock_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    DashboardScreen(), // The main content of the home page
    // TotalPayablePage(), // Total Payable Amount page
    // TotalSellPage(), // Total Sell page
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: _pages[_selectedIndex], // Update this line
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.money_off),
            label: 'Payable',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.attach_money),
            label: 'Sell',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        onTap: _onItemTapped,
      ),
    );
  }
}

/// Separate Dashboard content to avoid recursion
class DashboardScreen extends StatelessWidget {
  final List<Map<String, dynamic>> pages = [
    {
      'image': 'images/product.png',
      'name': 'Manage Products',
      'page': ProductsPage(),
    },
    {
      'image': 'images/customers.jpg',
      'name': 'Manage Customers',
      'page': CustomersPage(),
    },
    {
      'image': 'images/sales.jpg',
      'name': 'Manage Sales',
      'page': SalePage(),
    },
    {
      'image': 'images/payable_amount.jpg',
      'name': 'Manage Account Payables',
      'page': BorrowPage(),
    },
    {
      'image': 'images/stock.jpg',
      'name': 'Stock',
      'page': StockPage(),
    },
    // {
    //   'image': 'images/profit.png',
    //   'name': 'Profit',
    //   'page': ProfitPage(),
    // },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Center(
          child: Text(
            'Dashboard',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 30, color: AppColors.textOnPrimary),
          ),
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.only(right: 30),
            icon: Icon(Icons.logout, color: AppColors.textOnPrimary),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16.0,
            mainAxisSpacing: 16.0,
            childAspectRatio: 1,
          ),
          itemCount: pages.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => pages[index]['page']),
                );
              },
              child: Card(
                elevation: 4.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      pages[index]['image'],
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                    ),
                    SizedBox(height: 8.0),
                    Text(
                      pages[index]['name'],
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}