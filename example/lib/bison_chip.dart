import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Icons, Transform;
import 'package:widgetbook/widgetbook.dart' show KnobsExtension;
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:bison_design_system/core_widgets.dart'
    show
        BisonChip,
        ObjectChipStyle,
        BisonMenu,
        BisonMenuItem,
        BisonMenuTriggerAction,
        BisonDialog,
        BisonDialogAction;

/// A custom Icon that applies 45-degree rotation transformation.
class RotatedIcon extends Icon {
  const RotatedIcon(
    super.icon, {
    super.key,
    super.size,
    super.color,
    super.semanticLabel,
    super.textDirection,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 45 * 3.14159 / 180, // Convert 45 degrees to radians
      child: super.build(context),
    );
  }
}

@widgetbook.UseCase(name: 'Default', type: BisonChip)
Widget buildBisonChipUseCase(BuildContext context) {
  final leftIcon = context.knobs.objectOrNull.dropdown<Icon>(
    label: 'Left Icon',
    labelBuilder: (icon) => switch (icon.icon) {
      Icons.add => 'Add',
      Icons.arrow_drop_down => 'Dropdown',
      Icons.save => 'Save',
      Icons.delete => 'Delete',
      _ => '',
    },
    options: const [
      Icon(Icons.add),
      Icon(Icons.arrow_drop_down),
      Icon(Icons.save),
      Icon(Icons.delete),
    ],
  );
  final rightIcon = context.knobs.objectOrNull.dropdown<Icon>(
    label: 'Right Icon',
    labelBuilder: (icon) => switch (icon.icon) {
      Icons.add => 'Add',
      Icons.arrow_drop_down => 'Dropdown',
      Icons.save => 'Save',
      Icons.delete => 'Delete',
      _ => '',
    },
    options: const [
      Icon(Icons.add),
      Icon(Icons.arrow_drop_down),
      Icon(Icons.save),
      Icon(Icons.delete),
    ],
  );

  return BisonChip.object(
    label: context.knobs.string(label: 'Chip Label', initialValue: 'Label'),
    leftIcon: leftIcon,
    rightIcon: rightIcon,
    onLeftPressed: () => {},
    onRightPressed: () => {},
    objectChipStyle: context.knobs.object.dropdown(
      label: 'Object Style',
      labelBuilder: (value) => value.name,
      options: [
        ObjectChipStyle.normal,
        ObjectChipStyle.warning,
        ObjectChipStyle.danger,
      ],
    ),
  );
}

@widgetbook.UseCase(name: 'Device', type: BisonChip)
Widget buildBisonChipDeviceUseCase(BuildContext context) {
  final icon = context.knobs.object.dropdown<Icon>(
    label: 'Icon',
    labelBuilder: (icon) => switch (icon.icon) {
      Icons.circle_outlined => 'Analog',
      Icons.square_sharp => 'Digital',
      _ => '',
    },
    options: const [
      Icon(Icons.circle_outlined),
      RotatedIcon(Icons.square_sharp),
    ],
  );

  final chipType = context.knobs.object.dropdown(
    label: 'Device Severity',
    labelBuilder: (value) => value.name,
    initialOption: ObjectChipStyle.normal,
    options: [
      ObjectChipStyle.normal,
      ObjectChipStyle.warning,
      ObjectChipStyle.danger,
    ],
  );

  return BisonMenu(
    builder: (_, final focusNode, {required toggleMenu, required isOpen}) {
      return Focus(
        focusNode: focusNode,
        child: BisonChip.object(
          label: context.knobs.string(
            label: 'Device Name',
            initialValue: 'M:OUTTMP',
          ),
          leftIcon: icon,
          onLeftPressed: () {
            BisonDialog.show(
              context: context,
              title: 'M:OUTTMP',
              body:
                  'Open details for M:OUTTMP. Right-click the chip to access device actions.',
              primaryAction: BisonDialogAction(
                label: 'Close',
                onPressed: () {},
              ),
              secondaryAction: BisonDialogAction(
                label: 'Snooze',
                onPressed: () {},
              ),
            );
          },
          objectChipStyle: chipType,
        ),
      );
    },
    triggerAction: BisonMenuTriggerAction.secondary,
    items: [
      BisonMenuItem(
        label: 'Open details',
        icon: const Icon(Icons.info_outline),
        onSelect: () => {},
      ),
      BisonMenuItem(
        label: 'Snooze',
        icon: const Icon(Icons.access_time_outlined),
        onSelect: () => {},
      ),
      BisonMenuItem(
        label: 'Bypass',
        icon: const Icon(Icons.remove_moderator_outlined),
        onSelect: () => {},
      ),
      BisonMenuItem(
        label: 'Find parameter pages',
        icon: const Icon(Icons.search),
        onSelect: () => {},
      ),
      BisonMenuItem(
        label: 'Find lists',
        icon: const Icon(Icons.view_list),
        onSelect: () => {},
      ),
    ],
  );
}
