import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart' show KnobsExtension;
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:bison_design_system/core_widgets.dart'
    show BisonButton, BisonButtonType;

@widgetbook.UseCase(name: 'Default', type: BisonButton)
Widget buildBisonButtonUseCase(BuildContext context) {
  return bisonWidgetType(
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
    onPressed: context.knobs.boolean(label: 'Disabled') ? null : () => {},
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

enum BisonButtonType { filled, ghost, outlined, destructive }

BisonButton bisonWidgetType({
  required String buttonLabel,
  required BisonButtonType buttonType,
  required onPressed,
  icon,
}) {
  return switch (buttonType) {
    BisonButtonType.filled => BisonButton.filled(
      buttonLabel: buttonLabel,
      onPressed: onPressed,
      icon: icon,
    ),
    BisonButtonType.outlined => BisonButton.outlined(
      buttonLabel: buttonLabel,
      onPressed: onPressed,
      icon: icon,
    ),
    BisonButtonType.ghost => BisonButton.ghost(
      buttonLabel: buttonLabel,
      onPressed: onPressed,
      icon: icon,
    ),
    BisonButtonType.destructive => BisonButton.destructive(
      buttonLabel: buttonLabel,
      onPressed: onPressed,
      icon: icon,
    ),
  };
}
