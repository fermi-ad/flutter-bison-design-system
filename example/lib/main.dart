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
        brightness: Brightness.light,
        extensions: [BisonThemeTokens.light()],
        colorScheme: BisonThemeTokens.light().toColorScheme(Brightness.light),
        scaffoldBackgroundColor: BisonThemeTokens.light().surfaceDefault,
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        extensions: [BisonThemeTokens.dark()],
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
                  // BeemTextsTheme.main(View.of(context)),
                ],
              ),
            ),
            WidgetbookTheme(
              name: "Dark mode",
              data: Theme.of(context).copyWith(
                extensions: [
                  BisonThemeTokens.dark(),
                  // BeemTextsTheme.main(View.of(context)),
                ],
              ),
            ),
          ],
        ),
        // DeviceFrameAddon(
        //   devices: [
        //     Devices.android.samsungGalaxyS20,
        //     Devices.ios.iPhone13ProMax,
        //   ],
        // ),
        // TextScaleAddon(scales: [1.0, 1.5, 2.0], initialScale: 1.0),
      ],
    );
  }
}
