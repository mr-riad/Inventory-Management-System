import 'package:flutter/material.dart';
import 'package:invetory_management1/services/auth_service.dart';
import 'package:invetory_management1/utils/text_field.dart';
import 'package:provider/provider.dart';

class RegistrationPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Please",style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
            Text("Login your account",style: TextStyle(fontSize: 20,),),
            SizedBox(height: 60,),
            CustomTextField(hintText: 'Email', controller: _emailController,),
            SizedBox(height: 20),
            CustomTextField(hintText: 'Passwords', controller: _passwordController),
            SizedBox(height: 25),
            ElevatedButton(
              onPressed: () async {
                final user = await authService.register(
                  _emailController.text,
                  _passwordController.text,
                );
                if (user != null) {
                  Navigator.pushReplacementNamed(context, '/home');
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Registration failed!')),
                  );
                }
              },
              child: Text('Register'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushNamed(context, '/login');
              },
              child: Text('Already have an account? Login'),
            ),
          ],
        ),
      ),
    );
  }
}