import 'package:bison_design_system/theme.dart';

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
    final spacing = BisonSpacingTokens.standard();
    final corners = BisonCornerTokens.standard();

    final List<ThemeExtension<dynamic>> bisonExtensionsLight = [
      colorsLight,
      typographyLight,
      spacing,
      corners,
    ];
    final List<ThemeExtension<dynamic>> bisonExtensionsDark = [
      colorsDark,
      typographyDark,
      spacing,
      corners,
    ];

    final ThemeData lightTheme = ThemeData(
      fontFamily: 'Atkinson Hyperlegible Next',
      package: 'bison_design_system',
      brightness: Brightness.light,
      extensions: bisonExtensionsLight,
      colorScheme: colorsLight.toColorScheme(Brightness.light),
      scaffoldBackgroundColor: colorsLight.surfaceDefault,
    );
    final ThemeData darkTheme = ThemeData(
      fontFamily: 'Atkinson Hyperlegible Next',
      package: 'bison_design_system',
      brightness: Brightness.dark,
      extensions: bisonExtensionsDark,
      colorScheme: colorsDark.toColorScheme(Brightness.dark),
      scaffoldBackgroundColor: colorsDark.surfaceDefault,
    );

    return Widgetbook.material(
      appBuilder: (context, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: lightTheme,
        darkTheme: darkTheme,
        home: Material(child: child),
      ),
      lightTheme: lightTheme,
      darkTheme: darkTheme,
      themeMode: ThemeMode.system,
      directories: directories,
      addons: [AlignmentAddon()],
    );
  }
}
