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
  final String message =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.";
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
    body: Text(message),
    primaryAction: primary,
    secondaryAction: secondaryActionToggle,
    destructiveAction: destructiveActionToggle,
  );
}

@widgetbook.UseCase(name: 'Dialog with details', type: BisonDialog)
Widget buildBisonDialogDetails(BuildContext context) {
  final bison = context.bison;
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

  Widget dialogBody() {
    return Column(
      spacing: bison.spacing.microSpacing,
      crossAxisAlignment: .start,
      children: [
        Row(
          children: [
            Text(
              'Alarm Type:',
              style: TextStyle(color: bison.theme.textDisabled),
            ),
            Spacer(flex: 1),
            Text(textAlign: .end, "Normal"),
          ],
        ),
        Row(
          children: [
            Text('Status:', style: TextStyle(color: bison.theme.textDisabled)),
            Spacer(flex: 1),
            Text(textAlign: .end, "Active"),
          ],
        ),
        Row(
          children: [
            Text(
              'Device Description:',
              style: TextStyle(color: bison.theme.textDisabled),
            ),
            Spacer(flex: 1),
            Text(textAlign: .end, "Beam position nominal"),
          ],
        ),
        Divider(thickness: 1.0, color: bison.theme.textDisabled),
        Row(
          children: [
            Text(
              'TimeStamp:',
              style: TextStyle(color: bison.theme.textDisabled),
            ),
            Spacer(flex: 1),
            Text(textAlign: .end, "Apr 22, 2026, 01:39:05 PM"),
          ],
        ),
        Divider(thickness: 1.0, color: bison.theme.textDisabled),
        Row(
          children: [
            Text('Reading:', style: TextStyle(color: bison.theme.textDisabled)),
            Spacer(flex: 1),
            Text(textAlign: .end, "0.1240 mm"),
          ],
        ),
        Row(
          children: [
            Text('Minimum:', style: TextStyle(color: bison.theme.textDisabled)),
            Spacer(flex: 1),
            Text(textAlign: .end, "-2.000 mm"),
          ],
        ),
        Row(
          children: [
            Text('Maximum:', style: TextStyle(color: bison.theme.textDisabled)),
            Spacer(flex: 1),
            Text(textAlign: .end, "2.0000 mm"),
          ],
        ),
      ],
    );
  }

  return BisonDialog(
    title: dialogTitle,
    body: dialogBody(),
    primaryAction: primary,
    secondaryAction: secondaryActionToggle,
    destructiveAction: destructiveActionToggle,
  );
}

@widgetbook.UseCase(name: 'Trigger Dialog', type: BisonDialog)
Widget buildBisonDialogTrigger(BuildContext context) {
  final String dialogTitle = context.knobs.string(
    label: 'Dialog Title',
    initialValue: 'Dialog',
  );
  final String message =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.";
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
        body: Text(message),
        primaryAction: BisonDialogAction(label: 'Okay', onPressed: () {}),
        secondaryAction: secondaryActionToggle,
        destructiveAction: destructiveActionToggle,
        barrierDismissible: barrierDismissible,
      );
    },
  );
}
