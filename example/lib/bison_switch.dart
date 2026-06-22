import 'package:bison_design_system/core_widgets.dart'
    show BisonSwitch, BisonSwitchSize, BisonSwitchVariant;
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

    return BisonSwitch(
      value: _value,
      onChanged: variant == BisonSwitchVariant.normal
          ? (v) => setState(() {
              _value = v;
              _persistedSwitchValue = v;
            })
          : null,
      variant: variant,
      size: size,
      label: showLabel ? labelText : null,
      stateText: showStateText
          ? (_value ? positiveStateText : negativeStateText)
          : null,
    );
  }
}
