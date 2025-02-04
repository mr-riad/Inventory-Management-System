import 'package:flutter/material.dart';

class AppColors {
  // Primary Colors
  static const Color primary = Color(0xFF007BFF); // Blue - Main UI Elements
  static const Color primaryDark = Color(0xFF0056B3); // Darker Blue - Hover/Pressed State
  static const Color secondary = Color(0xFF17A2B8); // Teal - Secondary Highlights

  // Background & Surface
  static const Color background = Color(0xFFF8F9FA); // Light Gray - App Background
  static const Color surface = Color(0xFFFFFFFF); // White - Cards, Modals, Forms
  static const Color divider = Color(0xFFCED4DA);
  // Light Gray - Dividers & Borders

  // Text Colors
  static const Color textPrimary = Color(0xFF212529); // Dark Gray - Primary Text
  static const Color textSecondary = Color(0xFF6C757D); // Medium Gray - Secondary Text
  static const Color textOnPrimary = Color(0xFFFFFFFF); // White - Text on Primary Color

  // Status Colors
  static const Color success = Color(0xFF28A745); // Green - Success Messages
  static const Color warning = Color(0xFFFFC107); // Yellow - Warnings & Low Stock Alerts
  static const Color error = Color(0xFFDC3545); // Red - Errors & Critical Alerts
  static const Color info = Color(0xFF17A2B8); // Teal - Informational Messages

  // Action & Interactive Colors
  static const Color buttonPrimary = Color(0xFF007BFF); // Primary Buttons
  static const Color buttonSecondary = Color(0xFF6C757D); // Secondary Buttons
  static const Color buttonDisabled = Color(0xFFADB5BD); // Disabled Buttons

  // Other Colors
  static const Color stockHigh = Color(0xFF28A745); // Green - Sufficient Stock
  static const Color stockLow = Color(0xFFFFC107); // Yellow - Low Stock
  static const Color stockOut = Color(0xFFDC3545); // Red - Out of Stock
}
