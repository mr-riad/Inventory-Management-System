import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool obscureText;
  final TextEditingController controller;
  final IconData? suffixIcon;
  final VoidCallback? onSuffixIconTap;

  CustomTextField({
    required this.hintText,
    this.obscureText = false,
    required this.controller,
    this.suffixIcon,
    this.onSuffixIconTap,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _isObscure;

  @override
  void initState() {
    super.initState();
    _isObscure = widget.obscureText;
  }

  void _toggleObscure() {
    setState(() {
      _isObscure = !_isObscure;
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      obscureText: _isObscure,
      decoration: InputDecoration(
        hintText: widget.hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        suffixIcon: widget.suffixIcon != null
            ? GestureDetector(
          onTap: _toggleObscure,
          child: Icon(
            _isObscure ? Icons.visibility_off : Icons.visibility,
          ),
        )
            : null,
      ),
    );
  }
}
