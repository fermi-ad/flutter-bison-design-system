import 'package:bison_design_system/core_widgets.dart'
    show BisonSwitch, BisonSwitchSize, BisonSwitchVariant;
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart' show KnobsExtension;
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Switch', type: BisonSwitch)
Widget buildBisonSwitch(BuildContext context) {
  final variant = context.knobs.object.dropdown<BisonSwitchVariant>(
    label: 'Variant',
    options: BisonSwitchVariant.values,
    initialOption: BisonSwitchVariant.normal,
    labelBuilder: (v) => v.name,
  );

  final size = context.knobs.object.dropdown<BisonSwitchSize>(
    label: 'Size',
    options: BisonSwitchSize.values,
    initialOption: BisonSwitchSize.medium,
    labelBuilder: (s) => s.name,
  );

  final showLabel = context.knobs.boolean(
    label: 'Show label',
    initialValue: true,
  );
  final showStateText = context.knobs.boolean(
    label: 'Show state text',
    initialValue: true,
  );

  return _InteractiveSwitchUseCase(
    variant: variant,
    size: size,
    showLabel: showLabel,
    showStateText: showStateText,
  );
}

/// Stateful wrapper so the switch can actually toggle in the widgetbook preview.
class _InteractiveSwitchUseCase extends StatefulWidget {
  final BisonSwitchVariant variant;
  final BisonSwitchSize size;
  final bool showLabel;
  final bool showStateText;

  const _InteractiveSwitchUseCase({
    required this.variant,
    required this.size,
    required this.showLabel,
    required this.showStateText,
  });

  @override
  State<_InteractiveSwitchUseCase> createState() =>
      _InteractiveSwitchUseCaseState();
}

class _InteractiveSwitchUseCaseState extends State<_InteractiveSwitchUseCase> {
  bool _value = true;

  @override
  Widget build(BuildContext context) {
    return BisonSwitch(
      value: _value,
      onChanged: widget.variant == BisonSwitchVariant.normal
          ? (v) => setState(() => _value = v)
          : null,
      variant: widget.variant,
      size: widget.size,
      label: widget.showLabel ? 'Label' : null,
      stateText: widget.showStateText ? (_value ? 'On' : 'Off') : null,
    );
  }
}
