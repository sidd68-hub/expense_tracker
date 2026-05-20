import 'package:expense_tracker/config/theme/app_schema.dart';
import 'package:flutter/material.dart';

extension AppColorExtension on BuildContext{
  AppColorScheme get appColors {
    final colorScheme = Theme.of(this).extension<AppColorScheme>();
    assert(colorScheme != null, 'AppColorScheme is not found in ThemeData.extension');
    return colorScheme!;
  }
}