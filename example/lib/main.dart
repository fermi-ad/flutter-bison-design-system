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
      directories: directories,
      addons: [
        MaterialThemeAddon(
          themes: [
            WidgetbookTheme(
              name: "Light mode",
              data: Theme.of(context).copyWith(
                extensions: [
                  ColorsTheme.light(),
                  // BeemTextsTheme.main(View.of(context)),
                ],
              ),
            ),
            WidgetbookTheme(
              name: "Dark mode",
              data: Theme.of(context).copyWith(
                extensions: [
                  ColorsTheme.dark(),
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
