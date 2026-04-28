import 'package:bison_design_system/theme.dart' show BisonContext;
import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart' show KnobsExtension;
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:bison_design_system/core_widgets.dart'
    show BisonDialog, BisonDialogAction, BisonButton;

@widgetbook.UseCase(name: 'Dialog with Text', type: BisonDialog)
Widget buildBisonDialogText(BuildContext context) {
  final String dialogTitle = context.knobs.string(
    label: 'Dialog Title',
    initialValue: 'Dialog',
  );
  final String primaryActionLabel = context.knobs.string(
    label: 'Primary Action Label',
    initialValue: 'Confirm',
  );
  final String secondaryActionLabel = context.knobs.string(
    label: 'Secondary Action Label',
    initialValue: 'Cancel',
  );
  final String destructiveActionLabel = context.knobs.string(
    label: 'Destructive Action Label',
    initialValue: 'Destroy',
  );
  final secondaryActionToggle =
      context.knobs.boolean(label: 'Secondary Action', initialValue: true)
      ? BisonDialogAction(label: secondaryActionLabel, onPressed: () {})
      : null;
  final destructiveActionToggle =
      context.knobs.boolean(label: 'Destructive Action', initialValue: true)
      ? BisonDialogAction(label: destructiveActionLabel, onPressed: () {})
      : null;
  final BisonDialogAction primary = BisonDialogAction(
    label: primaryActionLabel,
    onPressed: () {},
  );

  return BisonDialog(
    title: dialogTitle,
    body: (context) => _buildDialogBody(context),
    primaryAction: primary,
    secondaryAction: secondaryActionToggle,
    destructiveAction: destructiveActionToggle,
  );
}

Widget _buildDialogBody(BuildContext context) {
  final bison = context.bison;
  return Column(
    spacing: bison.spacing.microSpacing,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        children: [
          Text(
            'Alarm Type:',
            style: TextStyle(color: bison.theme.textDisabled),
          ),
          Spacer(flex: 1),
          Text("Normal", textAlign: TextAlign.end),
        ],
      ),
      Row(
        children: [
          Text('Status:', style: TextStyle(color: bison.theme.textDisabled)),
          Spacer(flex: 1),
          Text("Active", textAlign: TextAlign.end),
        ],
      ),
      Row(
        children: [
          Text(
            'Device Description:',
            style: TextStyle(color: bison.theme.textDisabled),
          ),
          Spacer(flex: 1),
          Text("Beam position nominal", textAlign: TextAlign.end),
        ],
      ),
      Divider(thickness: 1.0, color: bison.theme.textDisabled),
      Row(
        children: [
          Text('Timestamp:', style: TextStyle(color: bison.theme.textDisabled)),
          Spacer(flex: 1),
          Text("Apr 22, 2026, 01:39:05 PM", textAlign: TextAlign.end),
        ],
      ),
      Divider(thickness: 1.0, color: bison.theme.textDisabled),
      Row(
        children: [
          Text('Reading:', style: TextStyle(color: bison.theme.textDisabled)),
          Spacer(flex: 1),
          Text("0.1240 mm", textAlign: TextAlign.end),
        ],
      ),
      Row(
        children: [
          Text('Minimum:', style: TextStyle(color: bison.theme.textDisabled)),
          Spacer(flex: 1),
          Text("-2.000 mm", textAlign: TextAlign.end),
        ],
      ),
      Row(
        children: [
          Text('Maximum:', style: TextStyle(color: bison.theme.textDisabled)),
          Spacer(flex: 1),
          Text("2.0000 mm", textAlign: TextAlign.end),
        ],
      ),
    ],
  );
}

@widgetbook.UseCase(name: 'Trigger Dialog', type: BisonDialog)
Widget buildBisonDialogTrigger(BuildContext context) {
  final String dialogTitle = context.knobs.string(
    label: 'Dialog Title',
    initialValue: 'Dialog',
  );
  final secondaryActionToggle =
      context.knobs.boolean(label: 'Secondary Action', initialValue: true)
      ? BisonDialogAction(label: 'Cancel', onPressed: () {})
      : null;
  final destructiveActionDisabled =
      context.knobs.boolean(
        label: 'Destructive Action Disabled',
        initialValue: false,
      )
      ? null
      : () {};
  final destructiveActionToggle =
      context.knobs.boolean(label: 'Destructive Action', initialValue: true)
      ? BisonDialogAction(
          label: 'Destroy',
          onPressed: destructiveActionDisabled,
        )
      : null;
  final barrierDismissible = context.knobs.boolean(
    label: 'Dismissible Barrier',
    initialValue: true,
  );
  return BisonButton.filled(
    buttonLabel: "Open Dialog",
    onPressed: () {
      BisonDialog.show(
        context: context,
        title: dialogTitle,
        body: (dialogContext) => _buildDialogBody(dialogContext),
        primaryAction: BisonDialogAction(label: 'Okay', onPressed: () {}),
        secondaryAction: secondaryActionToggle,
        destructiveAction: destructiveActionToggle,
        barrierDismissible: barrierDismissible,
      );
    },
  );
}
