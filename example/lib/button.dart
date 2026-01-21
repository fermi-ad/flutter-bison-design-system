import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:design_system/core_widgets.dart';

@widgetbook.UseCase(name: 'Default', type: Button)
Widget buildCoolButtonUseCase(BuildContext context) {
  return Button(
    buttonLabel: context.knobs.string(
      label: 'Button Label',
      initialValue: 'Button',
    ),
    buttonType: context.knobs.object.dropdown(
      label: 'Button Type',
      labelBuilder: (value) => value.name,
      options: [
        ButtonType.filled,
        ButtonType.ghost,
        ButtonType.outlined,
        ButtonType.destructive,
      ],
    ),
  );
}
