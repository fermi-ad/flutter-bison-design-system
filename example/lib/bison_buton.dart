import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:bison_design_system/core_widgets.dart';

@widgetbook.UseCase(name: 'Default', type: BisonButton)
Widget buildBisonButtonUseCase(BuildContext context) {
  return BisonButton(
    buttonLabel: context.knobs.string(
      label: 'Button Label',
      initialValue: 'Label',
    ),
    buttonType: context.knobs.object.dropdown(
      label: 'Button Type',
      labelBuilder: (value) => value.name,
      options: [
        BisonButtonType.filled,
        BisonButtonType.ghost,
        BisonButtonType.outlined,
        BisonButtonType.destructive,
      ],
    ),
    onPressed: context.knobs.boolean(label: 'Disabled')
        ? null
        : () => debugPrint("Hello!"),
    icon: context.knobs.objectOrNull.dropdown(
      label: 'Icon',
      labelBuilder: (icon) => switch (icon.icon) {
        Icons.add => "Add",
        Icons.save => "Save",
        Icons.delete => "Delete",
        _ => '',
      },
      options: [Icon(Icons.add), Icon(Icons.save), Icon(Icons.delete)],
    ),
  );
}
