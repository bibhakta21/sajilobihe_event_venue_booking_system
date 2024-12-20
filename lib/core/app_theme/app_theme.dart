import 'package:flutter/material.dart';

ThemeData getApplicationTheme() {
  return ThemeData(
    primarySwatch: Colors.red,
    scaffoldBackgroundColor: Colors.grey.shade200,
    fontFamily: 'Roboto Regular',
    appBarTheme: const AppBarTheme(
      color: Colors.redAccent, // Keeps the app bar blue
      elevation: 4,
      titleTextStyle: TextStyle(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        fontFamily: 'Roboto Bold',
        color: Colors.white,
      ),
      iconTheme: IconThemeData(
        color: Colors.white,
      ),
      centerTitle: true,
    ),
  );
}
