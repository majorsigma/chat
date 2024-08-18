import 'package:flutter/material.dart';
import 'package:gchat/constants.dart';

class AppTheme {
  static final lightTheme = ThemeData(
    fontFamily: "Roboto",
    scaffoldBackgroundColor: Colors.white,
    appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
    elevatedButtonTheme: const ElevatedButtonThemeData(
      style: ButtonStyle(
        backgroundColor: WidgetStatePropertyAll(AppColor.primaryColor),
        foregroundColor: WidgetStatePropertyAll(Colors.white),
        shape: WidgetStatePropertyAll(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(4)),
          ),
        ),
      ),
    ),
    inputDecorationTheme: const InputDecorationTheme(
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.grey)),
      hintStyle: TextStyle(
        color: Colors.grey,
        fontStyle: FontStyle.normal,
        fontWeight: FontWeight.w400,
      ),
    ),
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      selectedItemColor: AppColor.iconBackground,
      unselectedItemColor: Colors.grey,
      backgroundColor: Colors.white,
      selectedLabelStyle: TextStyle(
        fontSize: 11,
        color: AppColor.iconBackground,
      ),
      unselectedLabelStyle: TextStyle(fontSize: 11, color: Colors.grey),
    ),
    textTheme: const TextTheme(
      titleSmall: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      titleMedium: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      titleLarge: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      labelSmall: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
      labelMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
      labelLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
      bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
      bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
    ),
  );
}
