import 'package:cdmujer_app_prestamos/app/theme/app_colors.dart';
import 'package:flutter/material.dart';

abstract final class AppTheme {
  static ThemeData get lightTheme => _theme(Brightness.light);

  // Se declara desde ahora para facilitar la futura incorporación del selector.
  static ThemeData get darkTheme => _theme(Brightness.dark);

  static ThemeData _theme(Brightness brightness) {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: AppColors.primary,
      brightness: brightness,
    ).copyWith(
      primary: AppColors.primary,
      onPrimary: AppColors.onPrimary,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.primary,
          foregroundColor: AppColors.onPrimary,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.primary),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: AppColors.primary),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: AppColors.primary),
      ),
    );
  }
}
