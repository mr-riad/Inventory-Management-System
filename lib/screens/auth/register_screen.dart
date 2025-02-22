import 'package:flutter/material.dart';
import 'package:invetory_management1/providers/auth_provider.dart';
import 'package:invetory_management1/utils/button.dart';
import 'package:invetory_management1/utils/colors.dart';
import 'package:invetory_management1/utils/text_field.dart';
import 'package:provider/provider.dart';

class RegistrationPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final authProvider = Provider.of<AuthProvider>(context);

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
                "Create an Account",
                style: TextStyle(
                  fontSize: screenWidth * 0.08, // Responsive font size
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: screenHeight * 0.03),
              CustomTextField(
                hintText: 'Email',
                controller: _emailController,
              ),
              SizedBox(height: screenHeight * 0.02),
              CustomTextField(
                hintText: 'Password',
                controller: _passwordController,
                obscureText: true,
                suffixIcon: Icons.visibility,
              ),
              SizedBox(height: screenHeight * 0.02),
              CustomTextField(
                hintText: 'Confirm Password',
                controller: _confirmPasswordController,
                obscureText: true,
                suffixIcon: Icons.visibility,
              ),
              SizedBox(height: screenHeight * 0.03),
              Container(
                height: screenHeight * 0.07, // Responsive height
                width: double.infinity,
                child: CustomButton(
                  text: "Register",
                  onPressed: () async {
                    if (_passwordController.text != _confirmPasswordController.text) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Passwords do not match!',
                            style: TextStyle(color: AppColors.textOnPrimary),
                          ),
                        ),
                      );
                      return;
                    }

                    bool registered = await authProvider.register(
                      _emailController.text,
                      _passwordController.text,
                    );

                    if (registered) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Registration successful! Please login.',
                            style: TextStyle(color: AppColors.textOnPrimary),
                          ),
                        ),
                      );
                      Navigator.pushReplacementNamed(context, '/login');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Registration failed!',
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
                    'Already have an account?',
                    style: TextStyle(fontSize: screenWidth * 0.04), // Responsive font size
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/login');
                    },
                    child: Text(
                      'Login',
                      style: TextStyle(fontSize: screenWidth * 0.04), // Responsive font size
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}