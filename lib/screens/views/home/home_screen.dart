import 'package:flutter/material.dart';
import 'package:invetory_management1/providers/product_provider.dart';
import 'package:invetory_management1/providers/sale_provider.dart';
import 'package:invetory_management1/screens/views/home/bottom_page/total%20borrow/total_borrow_page.dart';
import 'package:invetory_management1/screens/views/home/bottom_page/total%20profit/profit_home_page.dart';
import 'package:invetory_management1/utils/colors.dart';
import 'package:provider/provider.dart';
import '../../auth/login_screen.dart';
import '../borrow/borrow_page.dart';
import '../borrow/total_due_page.dart';
import '../customers/customers_page.dart';
import '../product/product_pge.dart';
import '../profit/profit_page.dart';
import '../sales/sale_page.dart';
import '../sales_count/total_sell_page.dart';
import '../stcok/stock_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    DashboardScreen(), // The main content of the home page
    TotalDuePage(), // Total Payable Amount page
    TotalProfitPage(), // Total Sell page
  ];

  // Data load function
  void loadData() async {
    await context.read<SaleProvider>().fetchSales();
    await context.read<ProductProvider>().fetchProducts();
    debugPrint('Data Loaded');
  }

  @override
  void initState() {
    loadData();
    super.initState();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
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
            label: 'Total Profit',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
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
    {
      'image': 'images/profit.png',
      'name': 'Total Product Sell',
      'page': TotalSellPage(),
    },
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    // Determine the number of columns based on screen width
    final crossAxisCount = screenWidth > 600 ? 3 : 2;

    // Adjust font size and image size based on screen size
    final titleFontSize = screenWidth > 600 ? 40.0 : 30.0;
    final itemFontSize = screenWidth > 600 ? 22.0 : 18.0;
    final imageSize = screenWidth > 600 ? 120.0 : 80.0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        title: Center(
          child: Text(
            'Dashboard',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: titleFontSize,
              color: AppColors.textOnPrimary,
            ),
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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade50, Colors.blue.shade100],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 1,
            ),
            itemCount: pages.length,
            itemBuilder: (context, index) {
              return Card(
                elevation: 8.0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20.0),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => pages[index]['page']),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [Colors.blue.shade200, Colors.blue.shade400],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          pages[index]['image'],
                          width: imageSize,
                          height: imageSize,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          pages[index]['name'],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: itemFontSize,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}