import 'package:bison_design_system/core_widgets.dart'
    show BisonSwitch, BisonSwitchSize;
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart' show KnobsExtension;
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

// Persist preview value across Widgetbook-driven remounts.
bool _persistedSwitchValue = true;

@widgetbook.UseCase(name: 'Switch', type: BisonSwitch)
Widget buildBisonSwitch(BuildContext context) {
  return const _InteractiveSwitchUseCase();
}

/// Stateful wrapper so the switch can actually toggle in the widgetbook preview.
class _InteractiveSwitchUseCase extends StatefulWidget {
  const _InteractiveSwitchUseCase();

  @override
  State<_InteractiveSwitchUseCase> createState() =>
      _InteractiveSwitchUseCaseState();
}

class _InteractiveSwitchUseCaseState extends State<_InteractiveSwitchUseCase> {
  late bool _value;

  @override
  void initState() {
    super.initState();
    _value = _persistedSwitchValue;
  }

  @override
  Widget build(BuildContext context) {
    final size = context.knobs.object.dropdown<BisonSwitchSize>(
      label: 'Switch Size',
      options: BisonSwitchSize.values,
      initialOption: BisonSwitchSize.medium,
      labelBuilder: (s) => s.name,
    );

    final isDisabled = context.knobs.boolean(
      label: 'Disabled',
      initialValue: false,
    );

    final isReadOnly = context.knobs.boolean(
      label: 'Read-only',
      initialValue: false,
    );

    final isLoading = context.knobs.boolean(
      label: 'Loading',
      initialValue: false,
    );

    final labelText = context.knobs.string(
      label: 'Label Text',
      initialValue: 'Label',
    );

    final showLabel = context.knobs.boolean(
      label: 'Show label',
      initialValue: true,
    );

    final showStateLabels = context.knobs.boolean(
      label: 'Show state labels',
      initialValue: true,
    );

    final positiveStateText = context.knobs.string(
      label: 'On Label',
      initialValue: 'On',
    );

    final negativeStateText = context.knobs.string(
      label: 'Off Label',
      initialValue: 'Off',
    );

    final label = showLabel ? labelText : null;
    final onLabel = showStateLabels ? positiveStateText : null;
    final offLabel = showStateLabels ? negativeStateText : null;

    if (isReadOnly) {
      return BisonSwitch.readOnly(
        value: _value,
        size: size,
        label: label,
        onLabel: onLabel,
        offLabel: offLabel,
        isLoading: isLoading,
      );
    }

    return BisonSwitch(
      value: _value,
      onChanged: isDisabled
          ? null
          : (currentValue) => setState(() {
              _value = !currentValue;
              _persistedSwitchValue = _value;
            }),
      size: size,
      label: label,
      onLabel: onLabel,
      offLabel: offLabel,
      isLoading: isLoading,
    );
  }
}
