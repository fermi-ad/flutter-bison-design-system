import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart' show KnobsExtension;
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:bison_design_system/core_widgets.dart'
    show BisonDialog, BisonDialogAction, BisonButton;

@widgetbook.UseCase(name: 'Dialog', type: BisonDialog)
Widget builBisonDialog(BuildContext context) {
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
    body: message,
    primaryAction: primary,
    secondaryAction: secondaryActionToggle,
    destructiveAction: destructiveActionToggle,
  );
}

@widgetbook.UseCase(name: 'Trigger Dialog', type: BisonDialog)
Widget builBisonDialogTrigger(BuildContext context) {
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
        body: message,
        primaryAction: BisonDialogAction(label: 'Okay', onPressed: () {}),
        secondaryAction: secondaryActionToggle,
        destructiveAction: destructiveActionToggle,
        barrierDismissible: barrierDismissible,
      );
    },
  );
}
