// GENERATED CODE - DO NOT MODIFY BY HAND

import 'package:flutter/material.dart';
import 'color_tokens.g.dart';

class BisonTypographyTokens extends ThemeExtension<BisonTypographyTokens> {
  final TextStyle h1;
  final TextStyle h2;
  final TextStyle h3;
  final TextStyle bodyLarge;
  final TextStyle bodySmall;
  final TextStyle capitalizedLabel;

  const BisonTypographyTokens({
    required this.h1,
    required this.h2,
    required this.h3,
    required this.bodyLarge,
    required this.bodySmall,
    required this.capitalizedLabel,
  });

  factory BisonTypographyTokens.fromTokens(final BisonThemeTokens colors) {
    return BisonTypographyTokens(
      h1: TextStyle(
        fontFamily: 'Atkinson Hyperlegible Next',
        package: 'bison_design_system',
        fontSize: 20.0,
        fontWeight: FontWeight.w400,
        height: 1.0, // Multiplier: 20.0 / 20.0
        letterSpacing: 0.0,
        color: colors.textPlain,
      ),
      h2: TextStyle(
        fontFamily: 'Atkinson Hyperlegible Next',
        package: 'bison_design_system',
        fontSize: 18.0,
        fontWeight: FontWeight.w400,
        height: 1.1111111111111112, // Multiplier: 20.0 / 18.0
        letterSpacing: 0.0,
        color: colors.textPlain,
      ),
      h3: TextStyle(
        fontFamily: 'Atkinson Hyperlegible Next',
        package: 'bison_design_system',
        fontSize: 16.0,
        fontWeight: FontWeight.w500,
        height: 1.125, // Multiplier: 18.0 / 16.0
        letterSpacing: 0.0,
        color: colors.textPlain,
      ),
      bodyLarge: TextStyle(
        fontFamily: 'Atkinson Hyperlegible Next',
        package: 'bison_design_system',
        fontSize: 14.0,
        fontWeight: FontWeight.w500,
        height: 1.1428571428571428, // Multiplier: 16.0 / 14.0
        letterSpacing: 0.0,
        color: colors.textPlain,
      ),
      bodySmall: TextStyle(
        fontFamily: 'Atkinson Hyperlegible Next',
        package: 'bison_design_system',
        fontSize: 13.0,
        fontWeight: FontWeight.w400,
        height: 1.2307692307692308, // Multiplier: 16.0 / 13.0
        letterSpacing: 0.0,
        color: colors.textPlain,
      ),
      capitalizedLabel: TextStyle(
        fontFamily: 'Atkinson Hyperlegible Next',
        package: 'bison_design_system',
        fontSize: 12.0,
        fontWeight: FontWeight.w400,
        height: 1.3333333333333333, // Multiplier: 16.0 / 12.0
        letterSpacing: 0.25,
        color: colors.textPlain,
      ),
    );
  }

  @override
  BisonTypographyTokens copyWith({
    final TextStyle? h1,
    final TextStyle? h2,
    final TextStyle? h3,
    final TextStyle? bodyLarge,
    final TextStyle? bodySmall,
    final TextStyle? capitalizedLabel,
  }) {
    return BisonTypographyTokens(
      h1: h1 ?? this.h1,
      h2: h2 ?? this.h2,
      h3: h3 ?? this.h3,
      bodyLarge: bodyLarge ?? this.bodyLarge,
      bodySmall: bodySmall ?? this.bodySmall,
      capitalizedLabel: capitalizedLabel ?? this.capitalizedLabel,
    );
  }

  @override
  BisonTypographyTokens lerp(
    covariant final ThemeExtension<BisonTypographyTokens>? other,
    final double t,
  ) {
    if (other is! BisonTypographyTokens) return this;
    return BisonTypographyTokens(
      h1: TextStyle.lerp(h1, other.h1, t)!,
      h2: TextStyle.lerp(h2, other.h2, t)!,
      h3: TextStyle.lerp(h3, other.h3, t)!,
      bodyLarge: TextStyle.lerp(bodyLarge, other.bodyLarge, t)!,
      bodySmall: TextStyle.lerp(bodySmall, other.bodySmall, t)!,
      capitalizedLabel: TextStyle.lerp(
        capitalizedLabel,
        other.capitalizedLabel,
        t,
      )!,
    );
  }
}
