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
    return Widgetbook.material(
      appBuilder: (context, child) => Title(
        title: "Fermilab Widgetbook",
        color: BisonThemeTokens.light().borderPrimary,
        child: child,
      ),
      lightTheme: ThemeData(
        fontFamily: 'Atkinson Hyperlegible Next',
        package: 'design_system',
        brightness: Brightness.light,
        extensions: [
          BisonThemeTokens.light(),
          BisonSpacingTokens.standard(),
          BisonCornerTokens.standard(),
          BisonTypographyTokens.fromTokens(BisonThemeTokens.light()),
        ],
        colorScheme: BisonThemeTokens.light().toColorScheme(Brightness.light),
        scaffoldBackgroundColor: BisonThemeTokens.light().surfaceDefault,
      ),
      darkTheme: ThemeData(
        fontFamily: 'Atkinson Hyperlegible Next',
        package: 'design_system',
        brightness: Brightness.dark,
        extensions: [
          BisonThemeTokens.dark(),
          BisonSpacingTokens.standard(),
          BisonCornerTokens.standard(),
          BisonTypographyTokens.fromTokens(BisonThemeTokens.dark()),
        ],
        colorScheme: BisonThemeTokens.dark().toColorScheme(Brightness.dark),
        scaffoldBackgroundColor: BisonThemeTokens.dark().surfaceDefault,
      ),
      themeMode: ThemeMode.system,
      directories: directories,
      addons: [
        AlignmentAddon(),
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(
              name: "Light mode",
              data: Theme.of(context).copyWith(
                extensions: [
                  BisonThemeTokens.light(),
                  BisonSpacingTokens.standard(),
                  BisonCornerTokens.standard(),
                  BisonTypographyTokens.fromTokens(BisonThemeTokens.light()),
                  // BeemTextsTheme.main(View.of(context)),
                ],
              ),
            ),
            WidgetbookTheme(
              name: "Dark mode",
              data: Theme.of(context).copyWith(
                extensions: [
                  BisonThemeTokens.dark(),
                  BisonSpacingTokens.standard(),
                  BisonCornerTokens.standard(),
                  BisonTypographyTokens.fromTokens(BisonThemeTokens.dark()),
                  // BeemTextsTheme.main(View.of(context)),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
