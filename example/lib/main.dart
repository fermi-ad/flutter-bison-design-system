import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show BrowserContextMenu;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:widgetbook/widgetbook.dart' show Widgetbook, AlignmentAddon;
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:bison_design_system/theme.dart' show BisonThemeData;

import 'main.directories.g.dart' show directories;

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    // If running in web, disable browser's context menu
    BrowserContextMenu.disableContextMenu();
  }
  runApp(const WidgetbookApp());
}

@widgetbook.App()
class WidgetbookApp extends StatelessWidget {
  const WidgetbookApp({super.key});

  @override
  Widget build(BuildContext context) {
    final lightTheme = BisonThemeData.light();
    final darkTheme = BisonThemeData.dark();

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
