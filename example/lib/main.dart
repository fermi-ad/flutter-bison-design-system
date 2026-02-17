import 'package:design_system/theme.dart';

import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'main.directories.g.dart';

void main() {
  runApp(const WidgetbookApp());
}

@widgetbook.App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorsLight = BisonThemeTokens.light();
    final colorsDark = BisonThemeTokens.dark();
    final typographyLight = BisonTypographyTokens.fromTokens(colorsLight);
    final typographyDark = BisonTypographyTokens.fromTokens(colorsDark);

    final List<ThemeExtension<dynamic>> bisonExtensionsLight = [
      colorsLight,
      typographyLight,
      BisonSpacingTokens.standard(),
      BisonCornerTokens.standard(),
    ];
    final List<ThemeExtension<dynamic>> bisonExtensionsDark = [
      colorsDark,
      typographyDark,
      BisonSpacingTokens.standard(),
      BisonCornerTokens.standard(),
    ];

    return Widgetbook.material(
      appBuilder: (context, child) => Title(
        title: "Fermilab Widgetbook",
        color: colorsLight.borderPrimary,
        child: child,
      ),
      lightTheme: ThemeData(
        fontFamily: 'Atkinson Hyperlegible Next',
        package: 'design_system',
        brightness: Brightness.light,
        extensions: bisonExtensionsLight,
        colorScheme: colorsLight.toColorScheme(Brightness.light),
        scaffoldBackgroundColor: colorsLight.surfaceDefault,
      ),
      darkTheme: ThemeData(
        fontFamily: 'Atkinson Hyperlegible Next',
        package: 'design_system',
        brightness: Brightness.dark,
        extensions: bisonExtensionsDark,
        colorScheme: colorsDark.toColorScheme(Brightness.dark),
        scaffoldBackgroundColor: colorsDark.surfaceDefault,
      ),
      themeMode: ThemeMode.system,
      directories: directories,
      addons: [
        AlignmentAddon(),
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(
              name: "Light mode",
              data: Theme.of(
                context,
              ).copyWith(extensions: bisonExtensionsLight),
            ),
            WidgetbookTheme(
              name: "Dark mode",
              data: Theme.of(context).copyWith(extensions: bisonExtensionsDark),
            ),
          ],
        ),
      ],
    );
  }
}
