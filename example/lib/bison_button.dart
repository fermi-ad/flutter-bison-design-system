import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart' show KnobsExtension;
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:bison_design_system/core_widgets.dart' show BisonButton;

typedef _ButtonBuilder =
    BisonButton Function({
      required String buttonLabel,
      required VoidCallback? onPressed,
      Icon? icon,
    });

class _ButtonVariant {
  final String name;
  final _ButtonBuilder builder;

  const _ButtonVariant(this.name, this.builder);
}

const _variants = <_ButtonVariant>[
  _ButtonVariant('filled', BisonButton.filled),
  _ButtonVariant('ghost', BisonButton.ghost),
  _ButtonVariant('outlined', BisonButton.outlined),
  _ButtonVariant('destructive', BisonButton.destructive),
];

@widgetbook.UseCase(name: 'Default', type: BisonButton)
Widget buildBisonButtonUseCase(BuildContext context) {
  final variant = context.knobs.object.dropdown<_ButtonVariant>(
    label: 'Button Type',
    labelBuilder: (value) => value.name,
    options: _variants,
  );

  final buttonLabel = context.knobs.string(
    label: 'Button Label',
    initialValue: 'Label',
  );

  final onPressed = context.knobs.boolean(label: 'Disabled') ? null : () {};

  final icon = context.knobs.objectOrNull.dropdown<Icon>(
    label: 'Icon',
    labelBuilder: (icon) => switch (icon.icon) {
      Icons.add => 'Add',
      Icons.save => 'Save',
      Icons.delete => 'Delete',
      _ => '',
    },
    options: const [Icon(Icons.add), Icon(Icons.save), Icon(Icons.delete)],
  );

  return variant.builder(
    buttonLabel: buttonLabel,
    onPressed: onPressed,
    icon: icon,
  );
}
