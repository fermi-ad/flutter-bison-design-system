import 'package:bison_design_system/core_widgets.dart'
    show BisonSwitch, BisonSwitchSize, BisonSwitchVariant;
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart' show KnobsExtension;
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Switch', type: BisonSwitch)
Widget buildBisonSwitch(BuildContext context) {
  final variant = context.knobs.object.dropdown<BisonSwitchVariant>(
    label: 'State Variant',
    options: BisonSwitchVariant.values,
    initialOption: BisonSwitchVariant.normal,
    labelBuilder: (v) => v.name,
  );

  final size = context.knobs.object.dropdown<BisonSwitchSize>(
    label: 'Switch Size',
    options: BisonSwitchSize.values,
    initialOption: BisonSwitchSize.medium,
    labelBuilder: (s) => s.name,
  );

  final labelText = context.knobs.string(
    label: 'Label Text',
    initialValue: 'Label',
  );

  final showLabel = context.knobs.boolean(
    label: 'Show label',
    initialValue: true,
  );
  final showStateText = context.knobs.boolean(
    label: 'Show state text',
    initialValue: true,
  );

  final positiveStateText = context.knobs.string(
    label: 'Positive State',
    initialValue: 'On',
  );

  final negativeStateText = context.knobs.string(
    label: 'Negative State',
    initialValue: 'Off',
  );

  return _InteractiveSwitchUseCase(
    variant: variant,
    size: size,
    labelText: labelText,
    showLabel: showLabel,
    showStateText: showStateText,
    positiveStateText: positiveStateText,
    negativeStateText: negativeStateText,
  );
}

/// Stateful wrapper so the switch can actually toggle in the widgetbook preview.
class _InteractiveSwitchUseCase extends StatefulWidget {
  final BisonSwitchVariant variant;
  final BisonSwitchSize size;
  final String labelText;
  final bool showLabel;
  final bool showStateText;
  final String positiveStateText;
  final String negativeStateText;

  const _InteractiveSwitchUseCase({
    required this.variant,
    required this.size,
    required this.labelText,
    required this.showLabel,
    required this.showStateText,
    required this.positiveStateText,
    required this.negativeStateText,
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
      label: widget.showLabel ? widget.labelText : null,
      stateText: widget.showStateText
          ? (_value ? widget.positiveStateText : widget.negativeStateText)
          : null,
    );
  }
}
