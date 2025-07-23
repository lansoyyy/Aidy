import 'package:flutter/material.dart';

// Aidy App Color Palette (Educational)
const primary = Color(0xFF1976D2); // Primary blue
const accent = Color(0xFF43A047); // Accent green
const background = Color(0xFFF5F7FA); // Light background
const surface = Color(0xFFFFFFFF); // Surface color (white)
const textLight = Color(0xFF212121); // Primary text (dark grey)
const textGrey = Color(0xFF757575); // Secondary text (medium grey)
const buttonText = Color(0xFFFFFFFF); // Button text color (white)

// Legacy colors (keeping for backward compatibility)
const secondary = Color(0xFF64B5F6); // Light Blue
const darkPrimary = Color(0xFF0D47A1); // Dark Blue
const black = Color(0xFF212121); // Charcoal
const white = Color(0xFFFFFFFF); // White
const grey = Color(0xFFBDBDBD); // Light Grey

TimeOfDay parseTime(String timeString) {
  List<String> parts = timeString.split(':');
  return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
}
