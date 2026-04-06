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
  final chipLabel = context.knobs.string(
    label: 'Device Name',
    initialValue: 'M:OUTTMP',
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
  final dialogTitle = 'M:OUTTMP';
  final dialogMessage =
      'Open details for M:OUTTMP. Right-click the chip to access device actions.';

  return _buildObjectChip(
    context,
    chipType,
    chipLabel,
    icon,
    dialogTitle,
    dialogMessage,
  );
}

@widgetbook.UseCase(name: 'Grouping Navigation', type: BisonChip)
Widget buildBisonChiGroupUseCase(BuildContext context) {
  return Row(
    mainAxisAlignment: .center,
    spacing: 8.0,
    children: [
      _buildObjectChip(
        context,
        ObjectChipStyle.normal,
        'M:OUTTMP',
        Icon(Icons.circle_outlined),
        'M:OUTTMP',
        'Right-click the chip for access device actions.',
      ),
      _buildObjectChip(
        context,
        ObjectChipStyle.warning,
        'G:AMANDA',
        Icon(Icons.circle_outlined),
        'G:AMANDA',
        'Right-click the chip for access device actions.',
      ),
    ],
  );
}

Widget _buildObjectChip(
  BuildContext context,
  ObjectChipStyle chipType,
  String chipLabel,
  Icon leftIcon,
  String dialogTitle,
  String dialogMessage,
) {
  return BisonMenu(
    builder: (_, final focusNode, {required toggleMenu, required isOpen}) {
      return BisonChip.object(
        focusNode: focusNode,
        label: chipLabel,
        leftIcon: leftIcon,
        onLeftPressed: () {
          _buildObjectDialog(context, dialogTitle, dialogMessage);
        },
        objectChipStyle: chipType,
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

Future<void> _buildObjectDialog(
  BuildContext context,
  String dialogTitle,
  String dialogMessage,
) {
  return BisonDialog.show(
    context: context,
    title: dialogTitle,
    body: dialogMessage,
    primaryAction: BisonDialogAction(label: 'Close', onPressed: () {}),
    secondaryAction: BisonDialogAction(label: 'Snooze', onPressed: () {}),
  );
}
