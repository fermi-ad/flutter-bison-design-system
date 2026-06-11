import 'package:bison_design_system/core_widgets.dart'
    show BisonTextField, BisonTextFieldSize;
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart' show KnobsExtension;
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Text Field', type: BisonTextField)
Widget buildBisonTextField(BuildContext context) {
  return const _BisonTextFieldUseCase();
}

class _BisonTextFieldUseCase extends StatefulWidget {
  const _BisonTextFieldUseCase();

  @override
  State<_BisonTextFieldUseCase> createState() => _BisonTextFieldUseCaseState();
}

class _BisonTextFieldUseCaseState extends State<_BisonTextFieldUseCase> {
  @override
  Widget build(BuildContext context) {
    final BisonTextFieldSize size = context.knobs.object
        .dropdown<BisonTextFieldSize>(
          label: 'Size',
          options: BisonTextFieldSize.values,
          initialOption: BisonTextFieldSize.medium,
          labelBuilder: (value) => value.name,
        );

    final String labelText = context.knobs.string(
      label: 'Label',
      initialValue: 'Label',
    );
    final String helperText = context.knobs.string(
      label: 'Helper Text',
      initialValue: 'Helpful Text',
    );
    final String placeholderText = context.knobs.string(
      label: 'Placeholder Text',
    );

    final bool enabled = context.knobs.boolean(
      label: 'Enabled',
      initialValue: true,
    );
    final bool readOnly = context.knobs.boolean(label: 'Read Only');
    final bool isLoading = context.knobs.boolean(label: 'Loading (skeleton)');
    final bool hasWarning = context.knobs.boolean(label: 'Warning');
    final bool hasError = context.knobs.boolean(label: 'Error');
    final bool obscureText = context.knobs.boolean(label: 'Obscure Text');

    return Column(
      spacing: 12,
      children: [
        BisonTextField(
          label: labelText,
          helperText: helperText,
          placeholder: placeholderText,
          size: size,
          enabled: enabled,
          readOnly: readOnly,
          isLoading: isLoading,
          hasWarning: hasWarning,
          hasError: hasError,
          obscureText: obscureText,
        ),
      ],
    );
  }
}
