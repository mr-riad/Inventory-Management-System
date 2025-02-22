import 'package:flutter/material.dart';

class TotalBorrowPage extends StatefulWidget {
  const TotalBorrowPage({super.key});

  @override
  State<TotalBorrowPage> createState() => _TotalBorrowPageState();
}

class _TotalBorrowPageState extends State<TotalBorrowPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Total borrow")),
    );
  }
}
