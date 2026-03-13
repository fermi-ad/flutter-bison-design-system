import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart' show KnobsExtension;
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:bison_design_system/theme.dart' show BisonThemeTokens;
import 'package:bison_design_system/core_widgets.dart' show BisonIconButton;

@widgetbook.UseCase(name: 'Filled', type: BisonIconButton)
Widget buildBisonIconButtonFilledUseCase(BuildContext context) {
  return BisonIconButton.filled(
    icon: context.knobs.object.dropdown(
      label: 'Icon',
      initialOption: Icon(Icons.settings_outlined),
      labelBuilder: (icon) => switch (icon.icon) {
        Icons.add => "Add",
        Icons.save => "Save",
        Icons.delete => "Delete",
        Icons.settings_outlined => "Settings",
        _ => "Settings",
      },
      options: [
        Icon(Icons.settings_outlined),
        Icon(Icons.add),
        Icon(Icons.save),
        Icon(Icons.delete),
      ],
    ),
    onPressed: context.knobs.boolean(label: 'Disabled') ? null : () => {},
  );
}

@widgetbook.UseCase(name: 'Ghost', type: BisonIconButton)
Widget buildBisonIconButtonGhostUseCase(BuildContext context) {
  return BisonIconButton.ghost(
    icon: context.knobs.object.dropdown(
      label: 'Icon',
      initialOption: Icon(Icons.settings_outlined),
      labelBuilder: (icon) => switch (icon.icon) {
        Icons.add => "Add",
        Icons.save => "Save",
        Icons.delete => "Delete",
        Icons.settings_outlined => "Settings",
        _ => "Settings",
      },
      options: [
        Icon(Icons.settings_outlined),
        Icon(Icons.add),
        Icon(Icons.save),
        Icon(Icons.delete),
      ],
    ),
    onPressed: context.knobs.boolean(label: 'Disabled') ? null : () => {},
  );
}

@widgetbook.UseCase(name: 'White Ghost', type: BisonIconButton)
Widget buildBisonIconButtonWhiteGhostUseCase(BuildContext context) {
  return Container(
    padding: EdgeInsets.all(200),
    color: Theme.of(context).extension<BisonThemeTokens>()!.surfaceSlate,
    child: BisonIconButton.whiteGhost(
      icon: context.knobs.object.dropdown(
        label: 'Icon',
        initialOption: Icon(Icons.settings_outlined),
        labelBuilder: (icon) => switch (icon.icon) {
          Icons.add => "Add",
          Icons.save => "Save",
          Icons.delete => "Delete",
          Icons.settings_outlined => "Settings",
          _ => "Settings",
        },
        options: [
          Icon(Icons.settings_outlined),
          Icon(Icons.add),
          Icon(Icons.save),
          Icon(Icons.delete),
        ],
      ),
      onPressed: context.knobs.boolean(label: 'Disabled') ? null : () => {},
    ),
  );
}

@widgetbook.UseCase(name: 'Small Ghost', type: BisonIconButton)
Widget buildBisonIconButtonSmallGhostUseCase(BuildContext context) {
  return BisonIconButton.smallGhost(
    icon: context.knobs.object.dropdown(
      label: 'Icon',
      initialOption: Icon(Icons.settings_outlined),
      labelBuilder: (icon) => switch (icon.icon) {
        Icons.add => "Add",
        Icons.save => "Save",
        Icons.delete => "Delete",
        Icons.settings_outlined => "Settings",
        _ => "Settings",
      },
      options: [
        Icon(Icons.settings_outlined),
        Icon(Icons.add),
        Icon(Icons.save),
        Icon(Icons.delete),
      ],
    ),
    onPressed: context.knobs.boolean(label: 'Disabled') ? null : () => {},
  );
}

@widgetbook.UseCase(name: 'Outlined', type: BisonIconButton)
Widget buildBisonIconButtonOutlinedUseCase(BuildContext context) {
  return BisonIconButton.outlined(
    icon: context.knobs.object.dropdown(
      label: 'Icon',
      initialOption: Icon(Icons.settings_outlined),
      labelBuilder: (icon) => switch (icon.icon) {
        Icons.add => "Add",
        Icons.save => "Save",
        Icons.delete => "Delete",
        Icons.settings_outlined => "Settings",
        _ => "Settings",
      },
      options: [
        Icon(Icons.settings_outlined),
        Icon(Icons.add),
        Icon(Icons.save),
        Icon(Icons.delete),
      ],
    ),
    onPressed: context.knobs.boolean(label: 'Disabled') ? null : () => {},
  );
}
