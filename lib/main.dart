import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:invetory_management1/providers/account_payable_provider.dart';
import 'package:invetory_management1/providers/customers_provider.dart';
import 'package:invetory_management1/providers/product_provider.dart';
import 'package:invetory_management1/providers/sale_provider.dart';
import 'package:invetory_management1/screens/auth/login_screen.dart';
import 'package:invetory_management1/screens/auth/register_screen.dart';
import 'package:invetory_management1/screens/views/home/home_screen.dart';
import 'package:invetory_management1/services/auth_service.dart';
import 'package:provider/provider.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProductProvider()),
        ChangeNotifierProvider(create: (_) => CustomerProvider()),
        ChangeNotifierProvider(create: (_) => SaleProvider()),
        ChangeNotifierProvider(create: (_) => AccountPayableProvider()),
        Provider<AuthService>(
          create: (_) => AuthService(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Firebase Auth',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        initialRoute: '/login',
        routes: {
          '/login': (context) => LoginPage(),
          '/register': (context) => RegistrationPage(),
          '/home': (context) => HomePage(),

        },
      ),
    );
  }
}