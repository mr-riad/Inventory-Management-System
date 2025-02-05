import 'package:flutter/material.dart';
import 'package:invetory_management1/utils/button.dart';
import 'package:invetory_management1/utils/colors.dart';
import 'package:provider/provider.dart';
import '../../services/auth_service.dart';
import '../../utils/text_field.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authService = Provider.of<AuthService>(context);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Please",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold),
            ),
            Text(
              "Login your account",
              style: TextStyle(
                fontSize: 20,
              ),
            ),
            SizedBox(
              height: 60,
            ),
            CustomTextField(
              hintText: 'Email',
              controller: _emailController,
            ),
            SizedBox(height: 20),
            CustomTextField(
                hintText: 'Passwords', controller: _passwordController,
              obscureText: true,
              suffixIcon: Icons.remove_red_eye_sharp,
              onSuffixIconTap: () {
                print("Suffix icon tapped!");
              },

            ),
            SizedBox(height: 25),
            Container(
              height: 58,
              width: double.infinity,
              child: CustomButton(
                  text: "LogIn",
                  onPressed: () async {
                    final user = await authService.login(
                      _emailController.text,
                      _passwordController.text,
                    );
                    if (user != null) {
                      Navigator.pushReplacementNamed(context, '/home');
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text(
                          'Login failed!',
                          style: TextStyle(color: AppColors.textOnPrimary),
                        )),
                      );
                    }
                  },
                  backgroundColor: AppColors.buttonPrimary,
                  textColor: AppColors.textPrimary),
            ),
            const SizedBox(
              height: 30,
            ),
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
          ],
        ),
      ),
    );
  }
}
