import 'package:flutter/material.dart';

import 'color_tokens.g.dart';
import 'shape_spacing_tokens.g.dart';
import 'typography_tokens.g.dart';

/// Master theme data class that provides pre-configured ThemeData objects
/// with all necessary extensions for the Bison design system.
class BisonThemeData {
  static ColorScheme getColorScheme(final Brightness brightness) {
    final themeTokens = brightness == Brightness.light
        ? BisonThemeTokens.light()
        : BisonThemeTokens.dark();

    return ColorScheme(
      brightness: brightness,
      primary: themeTokens.borderPrimary,
      onPrimary: themeTokens.textInverse,
      primaryContainer: themeTokens.surfaceDefault,
      onPrimaryContainer: themeTokens.textPlain,
      primaryFixed: themeTokens.surfaceDefault,
      primaryFixedDim: themeTokens.surfaceDefault,
      onPrimaryFixed: themeTokens.textPlain,
      onPrimaryFixedVariant: themeTokens.textPlain,
      secondary: themeTokens.borderSecondary,
      onSecondary: themeTokens.textInverse,
      secondaryContainer: themeTokens.surfaceDefault,
      onSecondaryContainer: themeTokens.textPlain,
      secondaryFixed: themeTokens.surfaceDefault,
      secondaryFixedDim: themeTokens.surfaceDefault,
      onSecondaryFixed: themeTokens.textPlain,
      onSecondaryFixedVariant: themeTokens.textPlain,
      tertiary: themeTokens.borderPrimary,
      onTertiary: themeTokens.textInverse,
      tertiaryContainer: themeTokens.surfaceDefault,
      onTertiaryContainer: themeTokens.textPlain,
      tertiaryFixed: themeTokens.surfaceDefault,
      tertiaryFixedDim: themeTokens.surfaceDefault,
      onTertiaryFixed: themeTokens.textPlain,
      onTertiaryFixedVariant: themeTokens.textPlain,
      error: themeTokens.borderError,
      onError: themeTokens.textInverse,
      errorContainer: themeTokens.surfaceDefault,
      onErrorContainer: themeTokens.textPlain,
      surface: themeTokens.surfaceDefault,
      onSurface: themeTokens.textPlain,
      surfaceDim: themeTokens.surfaceDefault,
      surfaceBright: themeTokens.surfaceDefault,
      surfaceContainerLowest: themeTokens.surfaceDefault,
      surfaceContainerLow: themeTokens.surfaceDefault,
      surfaceContainer: themeTokens.surfaceDefault,
      surfaceContainerHigh: themeTokens.surfaceDefault,
      surfaceContainerHighest: themeTokens.surfaceDefault,
      onSurfaceVariant: themeTokens.textPlain,
      outline: themeTokens.borderPlain,
      outlineVariant: themeTokens.borderPlain,
      shadow: themeTokens.textPlain,
      scrim: themeTokens.surfaceDefault,
      inverseSurface: themeTokens.surfaceDefault,
      onInverseSurface: themeTokens.textPlain,
      inversePrimary: themeTokens.borderPrimary,
      surfaceTint: themeTokens.borderPrimary,
    );
  }

  static TextTheme getTextTheme(final BisonTypographyTokens typo) {
    return TextTheme(
      displayLarge: typo.h1,
      displayMedium: typo.h1,
      displaySmall: typo.h1,
      headlineLarge: typo.h2,
      headlineMedium: typo.h2,
      headlineSmall: typo.h2,
      titleLarge: typo.h3,
      titleMedium: typo.h3,
      titleSmall: typo.h3,
      bodyLarge: typo.bodyLarge,
      bodyMedium: typo.bodyLarge,
      bodySmall: typo.bodySmall,
      labelLarge: typo.capitalizedLabel,
      labelMedium: typo.capitalizedLabel,
      labelSmall: typo.capitalizedLabel,
    );
  }

  /// Creates a [ThemeData] for light mode with all required extensions.
  ///
  /// Returns a [ThemeData] object configured with:
  /// - Light [BisonThemeTokens]
  /// - Standard [BisonSpacingTokens]
  /// - Standard [BisonTypographyTokens]
  /// - Standard [BisonCornerTokens]
  /// - Appropriate [ColorScheme] and [TextTheme] defaults
  static ThemeData light() {
    final brightness = Brightness.light;
    final themeTokens = BisonThemeTokens.light();
    final typographyTokens = BisonTypographyTokens.fromTokens(themeTokens);

    return ThemeData(
      brightness: brightness,
      colorScheme: getColorScheme(brightness),
      textTheme: getTextTheme(typographyTokens),
      extensions: [
        themeTokens,
        BisonSpacingTokens.standard(),
        typographyTokens,
        BisonCornerTokens.standard(),
      ],
    );
  }

  /// Creates a [ThemeData] for dark mode with all required extensions.
  ///
  /// Returns a [ThemeData] object configured with:
  /// - Dark [BisonThemeTokens]
  /// - Standard [BisonSpacingTokens]
  /// - Standard [BisonTypographyTokens]
  /// - Standard [BisonCornerTokens]
  /// - Appropriate [ColorScheme] and [TextTheme] defaults
  static ThemeData dark() {
    final brightness = Brightness.dark;
    final themeTokens = BisonThemeTokens.dark();
    final typographyTokens = BisonTypographyTokens.fromTokens(themeTokens);

    return ThemeData(
      brightness: brightness,
      colorScheme: getColorScheme(brightness),
      textTheme: getTextTheme(typographyTokens),
      extensions: [
        themeTokens,
        BisonSpacingTokens.standard(),
        typographyTokens,
        BisonCornerTokens.standard(),
      ],
    );
  }
}
