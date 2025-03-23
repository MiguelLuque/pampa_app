import 'package:flutter/material.dart';
import 'package:pampa_app/core/theme/app_styles.dart';
import 'color_schemes.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      appBarTheme: const AppBarTheme(centerTitle: false, elevation: 0),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: AppStyles.primaryButton,
      ),
      cardTheme: CardTheme(
        shape: RoundedRectangleBorder(borderRadius: AppStyles.borderRadius),
        clipBehavior: Clip.antiAlias,
      ),
    );
  }
}
