import 'package:flutter/material.dart';
import '../../../utils/colors.dart';
import '../../auth/login_screen.dart';
import '../pages/total_payable_page.dart';
import '../pages/total_sell_page.dart';
import 'home_screen.dart';

class BottomNev extends StatefulWidget {
  @override
  _BottomNevState createState() => _BottomNevState();
}

class _BottomNevState extends State<BottomNev> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomePage(), // The main content of the home page
    TotalPayablePage(), // Total Payable Amount page
    TotalSellPage(), // Total Sell page
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

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