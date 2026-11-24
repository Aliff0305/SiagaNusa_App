import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF0B2545);
  static const Color primaryLight = Color(0xFF4C7BD9);
  static const Color secondary = Color(0xFF138A7E);

  // Jenis bencana
  static const Color earthquake = Color(0xFFE8710A);
  static const Color tsunami = Color(0xFF0277BD);
  static const Color wildfire = Color(0xFFC62828);

  // Semantik
  static const Color success = Color(0xFF2E7D32);
  static const Color warning = Color(0xFFF2A100);
  static const Color danger = Color(0xFFC62828);
  static const Color info = Color(0xFF1565C0);

  // Permukaan
  static const Color lightBackground = Color(0xFFF3F5F9);
  static const Color lightSurface = Colors.white;
  static const Color darkBackground = Color(0xFF0A111E);
  static const Color darkSurface = Color(0xFF141C2D);

  static const Color textSecondary = Color(0xFF6A7490);

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF0B2545), Color(0xFF1B4F8F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );
}
