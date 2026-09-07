import 'package:flutter/material.dart';

abstract final class AppTheme {
  static const Color _brandColor = Color(0xFFB6144B);
  static const Color _onBrandColor = Colors.white;

  static ThemeData get lightTheme => _theme(Brightness.light);

  // Se declara desde ahora para facilitar la futura incorporación del selector.
  static ThemeData get darkTheme => _theme(Brightness.dark);

  static ThemeData _theme(Brightness brightness) {
    final ColorScheme colorScheme = ColorScheme.fromSeed(
      seedColor: _brandColor,
      brightness: brightness,
    ).copyWith(
      primary: _brandColor,
      onPrimary: _onBrandColor,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: _brandColor,
          foregroundColor: _onBrandColor,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: _brandColor,
          foregroundColor: _onBrandColor,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: _brandColor,
          side: const BorderSide(color: _brandColor),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: _brandColor),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(foregroundColor: _brandColor),
      ),
    );
  }
}
