import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData light() {
    return ThemeData(
        primaryColor: Colors.black87,
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: Colors.black,
          ),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.black87,
          elevation: 0,
          iconTheme: IconThemeData(
            color: Colors.black,
          ),
        ),
        textTheme: const TextTheme(
          headlineSmall: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          headlineMedium: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          headlineLarge: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
          bodySmall: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
          bodyMedium: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          bodyLarge: TextStyle(
            fontSize: 18,
            color: Colors.black,
          ),
          displaySmall: TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
          displayMedium: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
          displayLarge: TextStyle(
            fontSize: 16,
            color: Colors.black,
          ),
          labelSmall: TextStyle(
            fontSize: 10,
            color: Colors.black,
          ),
          labelMedium: TextStyle(
            fontSize: 12,
            color: Colors.black,
          ),
          labelLarge: TextStyle(
            fontSize: 14,
            color: Colors.black,
          ),
        ));
  }
}
