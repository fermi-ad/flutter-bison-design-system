import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:bison_design_system/core_widgets.dart';

@widgetbook.UseCase(name: 'Default', type: BisonIconButton)
Widget buildBisonButtonUseCase(BuildContext context) {
  return BisonIconButton(
    icon: Icon(Icons.settings_outlined),
    onPressed: context.knobs.boolean(label: 'Disabled')
        ? null
        : () => debugPrint("Hello!"),
  );
}
