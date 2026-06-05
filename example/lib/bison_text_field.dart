import 'package:bison_design_system/core_widgets.dart'
    show BisonTextField, BisonTextFieldSize;
import 'package:flutter/widgets.dart';
import 'package:widgetbook/widgetbook.dart' show KnobsExtension;
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

String _firstNameDraft = '';
String _lastNameDraft = '';

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
  late final TextEditingController _firstNameController;
  late final TextEditingController _lastNameController;

  void _syncFirstNameDraft() {
    _firstNameDraft = _firstNameController.text;
  }

  void _syncLastNameDraft() {
    _lastNameDraft = _lastNameController.text;
  }

  @override
  void initState() {
    super.initState();
    _firstNameController = TextEditingController(text: _firstNameDraft);
    _lastNameController = TextEditingController(text: _lastNameDraft);
    _firstNameController.addListener(_syncFirstNameDraft);
    _lastNameController.addListener(_syncLastNameDraft);
  }

  @override
  void dispose() {
    _firstNameController.removeListener(_syncFirstNameDraft);
    _lastNameController.removeListener(_syncLastNameDraft);
    _firstNameController.dispose();
    _lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final BisonTextFieldSize size = context.knobs.object
        .dropdown<BisonTextFieldSize>(
          label: 'Size',
          options: BisonTextFieldSize.values,
          initialOption: BisonTextFieldSize.medium,
          labelBuilder: (value) => value.name,
        );

    return Column(
      spacing: 12,
      children: [
        BisonTextField(
          label: 'Test Label',
          helperText: 'Help me!!',
          placeholder: 'First Name',
          controller: _firstNameController,
          size: size,
          enabled: context.knobs.boolean(label: 'Enabled', initialValue: true),
          hasWarning: context.knobs.boolean(label: 'Warning'),
          hasError: context.knobs.boolean(label: 'Error'),
          obscureText: context.knobs.boolean(label: 'Obscure Text'),
        ),
        BisonTextField(
          label: 'Test Label',
          helperText: 'Help me!!',
          placeholder: 'Last Name',
          controller: _lastNameController,
          size: size,
        ),
      ],
    );
  }
}
