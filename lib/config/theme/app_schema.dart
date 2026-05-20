import 'package:flutter/material.dart';

@immutable
class AppColorScheme extends ThemeExtension<AppColorScheme> {
  final Color p0;
  final Color p1;
  final Color p2;

  const AppColorScheme({required this.p0, required this.p1, required this.p2});

  @override
  AppColorScheme copyWith({
    Color? p0,
    Color? p1,
    Color? p2,
  }) {
    return AppColorScheme(
      p0: p0 ?? this.p0,
      p1: p1 ?? this.p1,
      p2: p2 ?? this.p2,
    );
  }

  @override
  ThemeExtension<AppColorScheme> lerp(
      covariant ThemeExtension<AppColorScheme>? other, double t) {
    if (other is! AppColorScheme) return this;
    return AppColorScheme(p0: p0, p1: p1, p2: p2);
  }
}
