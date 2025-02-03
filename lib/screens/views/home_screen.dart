import 'package:flutter/material.dart';
import 'package:invetory_management1/utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Text("HomeScreen",style: TextStyle(color: AppColors.primaryColor),),
          Text("HomeScreen",style: TextStyle(color: AppColors.secondaryColor),),
          Text("HomeScreen",style: TextStyle(color: AppColors.backgroundColor),),
          Text("HomeScreen",style: TextStyle(color: AppColors.textColor),),
          Text("HomeScreen",style: TextStyle(color: AppColors.buttonColor),),
          Text("HomeScreen",style: TextStyle(color: AppColors.buttonTextColor),),
        ],
      ),
    );
  }
}
