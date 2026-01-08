import 'package:flutter/material.dart';

class AppColors {
  // Primary Brand Colors (Vibrant & Premium)
  static const Color primary = Color(0xFF6C63FF); // Modern Indigo
  static const Color primaryVariant = Color(0xFF5146E5);
  
  // Secondary / Accent
  static const Color accent = Color(0xFF00C853); // Success Green for availability
  static const Color secondary = Color(0xFFFF4081); // Pink for notifications/alerts

  // Status Colors (Functional)
  static const Color available = Color(0xFF00E676); // Bright Green
  static const Color occupied = Color(0xFFFF5252); // Soft Red
  static const Color closed = Color(0xFFB0BEC5); // Grey
  static const Color booked = Color(0xFFFFAB40); // Amber
  
  // Backgrounds (Dark Mode Focused)
  static const Color backgroundDark = Color(0xFF121212); // Deep Black
  static const Color surfaceDark = Color(0xFF1E1E1E); // Card Background
  static const Color scaffoldDark = Color(0xFF0A0A0A); 

  // Text Colors
  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xB3FFFFFF); // 70% White
  static const Color textCaption = Color(0x80FFFFFF); // 50% White

  // Glassmorphism Overlay
  static const Color glassWhite = Color(0x1AFFFFFF); // 10% White opacity
}
