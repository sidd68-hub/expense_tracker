import 'package:expense_tracker/config/theme/app_schema.dart';
import 'package:expense_tracker/config/theme/theme_type.dart';
import 'package:flutter/material.dart';


class AppTheme {
  static ThemeData getTheme(ThemeType themeType) {
    switch (themeType) {
      case ThemeType.light:
        return ThemeData(
          brightness: Brightness.light,
          extensions: const <ThemeExtension<dynamic>>[
            AppColorScheme(
              p0: Color(0x806A4CBD),
              p1: Color(0xFFC89EE0),
              p2: Color(0xFF9867C5),
            ),
          ],
        );
      case ThemeType.dark:
        return ThemeData(
          brightness: Brightness.dark,
          extensions: const <ThemeExtension<dynamic>>[
            AppColorScheme(
              p0: Color(0xFFFDC3FE),
              p1: Color(0xFF9FE8DF),
              p2: Color(0xFF4DCBB1),
            ),
          ],
        );
    // fallback
    }
  }
}







