import 'package:flutter/material.dart';
import 'package:invetory_management1/services/auth_service.dart';
import 'package:invetory_management1/utils/button.dart';
import 'package:invetory_management1/utils/colors.dart';
import 'package:invetory_management1/utils/text_field.dart';
import 'package:provider/provider.dart';

class RegistrationPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Please",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            Text("Login your account", style: TextStyle(fontSize: 20)),
            SizedBox(height: 60),
            CustomTextField(
              hintText: 'Email',
              obscureText: false,
              controller: _emailController,
            ),
            SizedBox(height: 20),
            CustomTextField(
              hintText: 'Password',
              obscureText: true,
              controller: _passwordController,
              suffixIcon: Icons.visibility,
            ),
            SizedBox(height: 20),
            CustomTextField(
              hintText: 'Confirm Password',
              obscureText: true,
              controller: _confirmPasswordController,
              suffixIcon: Icons.visibility,
            ),
            SizedBox(height: 25),
            Container(
              height: 58,
              width: double.infinity,
              child: CustomButton(
                text: "Register",
                onPressed: () async {
                  if (_passwordController.text !=
                      _confirmPasswordController.text) {
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

                  final user = await authService.register(
                    _emailController.text,
                    _passwordController.text,
                  );
                  if (user != null) {
                    Navigator.pushReplacementNamed(context, '/home');
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
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Already have an account?'),
                TextButton(
                  onPressed: () {
                    Navigator.pushNamed(context, '/login');
                  },
                  child: Text('Login'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}