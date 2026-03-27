import 'package:flutter/material.dart';

import 'color_tokens.g.dart' show BisonThemeTokens;
import 'shape_spacing_tokens.g.dart' show BisonSpacingTokens, BisonCornerTokens;
import 'typography_tokens.g.dart' show BisonTypographyTokens;

import '../core_widgets/buttons/bison_button.dart'
    show
        getFilledBisonButtonStyle,
        getGhostBisonButtonStyle,
        getOutlinedBisonButtonStyle;
import '../core_widgets/buttons/bison_icon_button.dart'
    show filledIconButtonStyle;
import '../core_widgets/menus/bison_menu.dart'
    show getBisonMenuStyle, getBisonMenuButtonStyle;

/// Master theme data class that provides pre-configured ThemeData objects
/// with all necessary extensions for the Bison design system.
class BisonThemeData {
  /// Creates a [ThemeData] for light mode with all required extensions.
  ///
  /// Returns a [ThemeData] object configured with:
  /// - Light [BisonThemeTokens]
  /// - Standard [BisonSpacingTokens]
  /// - Standard [BisonTypographyTokens]
  /// - Standard [BisonCornerTokens]
  /// - Appropriate [ColorScheme] and [TextTheme] defaults
  static ThemeData light() {
    return _createTheme(Brightness.light);
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
    return _createTheme(Brightness.dark);
  }

  /// Helper method to create ThemeData with common configuration.
  static ThemeData _createTheme(final Brightness brightness) {
    final themeTokens = brightness == Brightness.light
        ? BisonThemeTokens.light()
        : BisonThemeTokens.dark();
    final spacingTokens = BisonSpacingTokens.standard();
    final cornerTokens = BisonCornerTokens.standard();
    final typographyTokens = BisonTypographyTokens.fromTokens(themeTokens);

    return ThemeData(
      brightness: brightness,
      fontFamily: 'Atkinson Hyperlegible Next',
      package: 'bison_design_system',
      colorScheme: getColorScheme(brightness),
      textTheme: getTextTheme(typographyTokens),
      // These presets allow us to style base Material widgets like we do in our
      // custom Bison widgets. As we add new Bison widgets, consider setting the
      // appropriate base Material widget styles here as well.
      filledButtonTheme: FilledButtonThemeData(
        style: getFilledBisonButtonStyle(
          themeTokens,
          spacingTokens,
          cornerTokens,
          typographyTokens,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: getGhostBisonButtonStyle(
          themeTokens,
          spacingTokens,
          cornerTokens,
          typographyTokens,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: getOutlinedBisonButtonStyle(
          themeTokens,
          spacingTokens,
          cornerTokens,
          typographyTokens,
        ),
      ),
      iconButtonTheme: IconButtonThemeData(
        style: filledIconButtonStyle(
          themeTokens,
          spacingTokens,
          cornerTokens,
          typographyTokens,
        ),
      ),
      menuTheme: MenuThemeData(
        style: getBisonMenuStyle(themeTokens, spacingTokens, cornerTokens),
      ),
      menuButtonTheme: MenuButtonThemeData(
        style: getBisonMenuButtonStyle(
          themeTokens,
          spacingTokens,
          typographyTokens,
        ),
      ),
      extensions: [
        themeTokens,
        BisonSpacingTokens.standard(),
        typographyTokens,
        BisonCornerTokens.standard(),
      ],
    );
  }

  static ColorScheme getColorScheme(final Brightness brightness) {
    final themeTokens = brightness == Brightness.light
        ? BisonThemeTokens.light()
        : BisonThemeTokens.dark();

    return ColorScheme(
      brightness: brightness,

      // Primary group.
      primary: themeTokens.buttonPrimary,
      onPrimary: themeTokens.textInverse,
      primaryContainer: themeTokens.surfaceHovered,
      onPrimaryContainer: themeTokens.textPlain,
      // Secondary group.
      secondary: themeTokens.borderSecondary,
      onSecondary: themeTokens.textInverse,
      secondaryContainer: themeTokens.surfaceHovered,
      onSecondaryContainer: themeTokens.textPlain,
      // Tertiary group – use the same color as primary for now;
      // we can replace it with a dedicated accent token later.
      tertiary: themeTokens.buttonPrimary,
      onTertiary: themeTokens.textInverse,
      tertiaryContainer: themeTokens.surfaceHovered,
      onTertiaryContainer: themeTokens.textPlain,
      // Error group.
      error: themeTokens.borderError,
      onError: themeTokens.textInverse,
      errorContainer: themeTokens.surfaceHovered,
      onErrorContainer: themeTokens.textPlain,
      // Surface hierarchy – the various surface tokens give depth.
      surface: themeTokens.surfaceDefault,
      onSurface: themeTokens.textPlain,
      surfaceDim: themeTokens.surfacePressed,
      surfaceBright: themeTokens.surfaceHovered,
      surfaceContainerLowest: themeTokens.surfaceTransparent,
      surfaceContainerLow: themeTokens.surfaceDefault,
      surfaceContainer: themeTokens.surfaceHovered,
      surfaceContainerHigh: themeTokens.surfacePressed,
      surfaceContainerHighest: themeTokens.surfacePressed,
      // Outline & variants.
      outline: themeTokens.borderPlain,
      outlineVariant: themeTokens.borderSecondary,
      // Shadows & scrims – use black with opacity.
      shadow: Color.fromARGB((0.2 * 255).round(), 0, 0, 0), // 20 % opacity
      scrim: Color.fromARGB((0.5 * 255).round(), 0, 0, 0), // 50 % opacity
      // Inverse colors – simply invert the surface palette.
      inverseSurface: themeTokens.surfaceInverse,
      onInverseSurface: themeTokens.textInverse,
      inversePrimary: themeTokens.buttonInverse,
      // Surface tint – usually the primary color.
      surfaceTint: themeTokens.buttonPrimary,
    );
  }

  static TextTheme getTextTheme(final BisonTypographyTokens typo) {
    return TextTheme(
      // Display.
      displayLarge: typo.h1,
      displayMedium: typo.h1,
      displaySmall: typo.h1,
      // Headline.
      headlineLarge: typo.h2,
      headlineMedium: typo.h2,
      headlineSmall: typo.h2,
      // Title.
      titleLarge: typo.h3,
      titleMedium: typo.h3,
      titleSmall: typo.h3,
      // Body.
      bodyLarge: typo.bodyLarge,
      bodyMedium: typo.bodyLarge,
      bodySmall: typo.bodySmall,
      // Label.
      labelLarge: typo.capitalizedLabel,
      labelMedium: typo.capitalizedLabel,
      labelSmall: typo.capitalizedLabel,
    );
  }
}

/// A snapshot of all Bison design-system tokens resolved from a [BuildContext].
///
/// Obtain an instance through [BisonContext.bison]:
///
/// ```dart
/// // Inline
/// Container(color: context.bison.theme.surfaceDefault);
///
/// // Or capture once when you need several tokens
/// final tokens = context.bison;
/// Text('Hello', style: tokens.typography.h2);
/// ```
final class BisonTokens {
  /// Semantic color tokens that adapt to the current light/dark theme.
  ///
  /// Covers surfaces, borders, buttons, icons, text, input fields, chips,
  /// and color-coded meanings (danger, warning, success, etc.).
  ///
  /// ```dart
  /// Container(color: context.bison.theme.surfaceDefault);
  /// Icon(Icons.check, color: context.bison.theme.iconSuccess);
  /// ```
  final BisonThemeTokens theme;

  /// Spacing scale used for padding, margins, and gaps.
  ///
  /// Values range from `noneSpacing` (0) to `xLargeSpacing` (64), with
  /// named steps in between: `micro` (4), `tiny` (8), `xSmall` (12),
  /// `small` (16), `standard` (24), `medium` (36), and `large` (48).
  ///
  /// ```dart
  /// Padding(
  ///   padding: EdgeInsets.all(context.bison.spacing.smallSpacing),
  /// );
  /// ```
  final BisonSpacingTokens spacing;

  /// Text styles for the Bison type scale.
  ///
  /// Available styles: `h1`, `h2`, `h3`, `bodyLarge`, `bodySmall`, and
  /// `capitalizedLabel`. All styles use the Atkinson Hyperlegible Next
  /// typeface and inherit their color from the current theme.
  ///
  /// ```dart
  /// Text('Section title', style: context.bison.typography.h2);
  /// ```
  final BisonTypographyTokens typography;

  /// Border-radius scale for rounded corners.
  ///
  /// Values range from `cornerNone` (0) to `cornerLarge` (16), with named
  /// steps: `cornerExtraSmall` (4), `cornerSmall` (8), and
  /// `cornerMedium` (12).
  ///
  /// ```dart
  /// ClipRRect(
  ///   borderRadius: BorderRadius.circular(context.bison.corners.cornerSmall),
  /// );
  /// ```
  final BisonCornerTokens corners;

  const BisonTokens({
    required this.theme,
    required this.spacing,
    required this.typography,
    required this.corners,
  });

  /// Resolves all tokens from the nearest Bison theme in [context].
  ///
  /// Throws a [StateError] if the Bison theme extensions are not present,
  /// which happens when the app's [ThemeData] was not created with
  /// [BisonThemeData.light] or [BisonThemeData.dark].
  factory BisonTokens.of(BuildContext context) {
    T resolve<T extends ThemeExtension<T>>() {
      return Theme.of(context).extension<T>() ??
          (throw StateError(
            '$T not found in the current theme. '
            'Ensure your MaterialApp uses BisonThemeData.light() or '
            'BisonThemeData.dark() as its theme.',
          ));
    }

    return BisonTokens(
      theme: resolve<BisonThemeTokens>(),
      spacing: resolve<BisonSpacingTokens>(),
      typography: resolve<BisonTypographyTokens>(),
      corners: resolve<BisonCornerTokens>(),
    );
  }
}

extension BisonContext on BuildContext {
  /// Returns a snapshot of all Bison design-system tokens resolved from this
  /// context.
  ///
  /// Tokens are grouped into the following categories:
  ///
  /// - [BisonTokens.theme] — semantic colors (surfaces, borders, buttons,
  ///   icons, text, input fields, chips, color-coded meanings).
  /// - [BisonTokens.spacing] — spacing scale from `noneSpacing` (0) to
  ///   `xLargeSpacing` (64).
  /// - [BisonTokens.typography] — text styles (`h1`–`h3`, `bodyLarge`,
  ///   `bodySmall`, `capitalizedLabel`).
  /// - [BisonTokens.corners] — border-radius scale from `cornerNone` (0) to
  ///   `cornerLarge` (16).
  ///
  /// ```dart
  /// // Single token
  /// Container(color: context.bison.theme.surfaceDefault);
  ///
  /// // Multiple tokens — capture once to avoid redundant lookups
  /// final tokens = context.bison;
  /// return Padding(
  ///   padding: EdgeInsets.all(tokens.spacing.standardSpacing),
  ///   child: Text('Hello', style: tokens.typography.bodyLarge),
  /// );
  /// ```
  BisonTokens get bison => BisonTokens.of(this);
}
