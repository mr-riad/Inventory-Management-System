import 'package:flutter/material.dart';
import 'package:invetory_management1/providers/auth_provider.dart';
import 'package:invetory_management1/utils/button.dart';
import 'package:invetory_management1/utils/colors.dart';
import 'package:provider/provider.dart';
import '../../utils/text_field.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(screenWidth * 0.05), // Responsive padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: screenHeight * 0.1),
              Text(
                "Please",
                style: TextStyle(
                    fontSize: screenWidth * 0.08, fontWeight: FontWeight.bold),
              ),
              Text(
                "Login your account",
                style: TextStyle(
                  fontSize: screenWidth * 0.05,
                ),
              ),
              SizedBox(height: screenHeight * 0.05),
              CustomTextField(
                hintText: 'Email',
                controller: _emailController,
              ),
              SizedBox(height: screenHeight * 0.02),
              CustomTextField(
                hintText: 'Password',
                controller: _passwordController,
                obscureText: true,
                suffixIcon: Icons.remove_red_eye_sharp,
                onSuffixIconTap: () {
                  print("Suffix icon tapped!");
                },
              ),
              SizedBox(height: screenHeight * 0.03),
              Container(
                height: screenHeight * 0.07,
                width: double.infinity,
                child: CustomButton(
                  text: "LogIn",
                  onPressed: () async {
                    var authProvider = context.read<AuthProvider>();
                    final user = await authProvider.login(
                      _emailController.text,
                      _passwordController.text,
                    );
                    if (user == true) {
                      Navigator.pushReplacementNamed(context, '/home');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Login failed!',
                            style: TextStyle(color: AppColors.textOnPrimary),
                          ),
                        ),
                      );
                    }
                  },
                  backgroundColor: AppColors.buttonPrimary,
                  textColor: AppColors.textPrimary,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "New User?",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Text(
                      'Create an account',
                    ),
                  ),
                ],
              ),
              SizedBox(height: screenHeight * 0.02),
              // Forgot password section
              GestureDetector(
                onTap: () async {
                  String email = _emailController.text;
                  if (email.isNotEmpty) {
                    //await authService.sendPasswordResetEmail(email);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Password reset link sent!')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Please enter your email')),
                    );
                  }
                },
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                    fontSize: screenWidth * 0.04,
                    fontWeight: FontWeight.bold,
                    color: AppColors.buttonPrimary,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
