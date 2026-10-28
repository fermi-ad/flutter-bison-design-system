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
    builder: (_, focusNode, {required toggleMenu, required isOpen}) {
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
    body: (context) => Text(dialogMessage),
    primaryAction: BisonDialogAction(label: 'Close', onPressed: () {}),
    secondaryAction: BisonDialogAction(label: 'Snooze', onPressed: () {}),
  );
}

/// Filter chips narrow a collection: several can be selected at once and each
/// toggles independently. Here they filter a device list by severity.
@widgetbook.UseCase(name: 'Filter a Device List', type: BisonChip)
Widget buildBisonChipFilterUseCase(BuildContext context) {
  return _FilterChipDemo(
    enabled: context.knobs.boolean(label: 'Enabled', initialValue: true),
  );
}

class _FilterChipDemo extends StatefulWidget {
  final bool enabled;

  const _FilterChipDemo({required this.enabled});

  @override
  State<_FilterChipDemo> createState() => _FilterChipDemoState();
}

class _FilterChipDemoState extends State<_FilterChipDemo> {
  final Set<String> _selectedSeverities = {'Alarms'};

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: .center,
      spacing: 8.0,
      children: [
        for (final severity in const ['Alarms', 'Warnings', 'Bypassed'])
          BisonChip.filter(
            label: severity,
            selected: _selectedSeverities.contains(severity),
            enabled: widget.enabled,
            leftIcon: _selectedSeverities.contains(severity)
                ? const Icon(Icons.check)
                : null,
            onLeftPressed: () => setState(() {
              if (_selectedSeverities.contains(severity)) {
                _selectedSeverities.remove(severity);
              } else {
                _selectedSeverities.add(severity);
              }
            }),
          ),
      ],
    );
  }
}

/// Input chips represent discrete pieces of information entered by someone,
/// such as devices added to an alarm notification list. Each chip can be
/// removed with its trailing icon. Input chips have no disabled state.
@widgetbook.UseCase(name: 'Input Entered Devices', type: BisonChip)
Widget buildBisonChipInputUseCase(BuildContext context) {
  return const _InputChipDemo();
}

class _InputChipDemo extends StatefulWidget {
  const _InputChipDemo();

  @override
  State<_InputChipDemo> createState() => _InputChipDemoState();
}

class _InputChipDemoState extends State<_InputChipDemo> {
  final List<String> _enteredDevices = ['M:OUTTMP', 'G:AMANDA', 'B:VIMIN'];

  @override
  Widget build(BuildContext context) {
    if (_enteredDevices.isEmpty) {
      return const Text('All devices removed.');
    }
    return Row(
      mainAxisAlignment: .center,
      spacing: 8.0,
      children: [
        for (final device in _enteredDevices)
          BisonChip.input(
            label: device,
            rightIcon: const Icon(Icons.close),
            onRightPressed: () => setState(() {
              _enteredDevices.remove(device);
            }),
          ),
      ],
    );
  }
}

/// Suggestion chips present dynamically-generated options that help narrow a
/// person's intent, such as completing a device search query. Choosing one
/// suggestion selects it and deselects the others.
@widgetbook.UseCase(name: 'Suggest Search Queries', type: BisonChip)
Widget buildBisonChipSuggestionUseCase(BuildContext context) {
  return _SuggestionChipDemo(
    enabled: context.knobs.boolean(label: 'Enabled', initialValue: true),
  );
}

class _SuggestionChipDemo extends StatefulWidget {
  final bool enabled;

  const _SuggestionChipDemo({required this.enabled});

  @override
  State<_SuggestionChipDemo> createState() => _SuggestionChipDemoState();
}

class _SuggestionChipDemoState extends State<_SuggestionChipDemo> {
  String? _chosenQuery;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: .center,
      spacing: 8.0,
      children: [
        Text('Search: ${_chosenQuery ?? ''}'),
        Row(
          mainAxisAlignment: .center,
          spacing: 8.0,
          children: [
            for (final suggestion in const [
              'Outdoor temperature',
              'Alarm limits',
              'Recent devices',
            ])
              BisonChip.suggestion(
                label: suggestion,
                selected: _chosenQuery == suggestion,
                enabled: widget.enabled,
                onLeftPressed: () => setState(() {
                  _chosenQuery = suggestion;
                }),
              ),
          ],
        ),
      ],
    );
  }
}
