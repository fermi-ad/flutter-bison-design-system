import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart' show KnobsExtension;
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:bison_design_system/core_widgets.dart'
    show BisonDialog, BisonDialogAction, BisonButton;

@widgetbook.UseCase(name: 'Default', type: BisonDialog)
Widget builBisonDialog(BuildContext context) {
  final String message =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.";

  final BisonDialogAction primary = BisonDialogAction(
    label: "Action",
    onPressed: () {},
  );
  final BisonDialogAction secondary = BisonDialogAction(
    label: "Cancel",
    onPressed: () {},
  );
  final BisonDialogAction destructive = BisonDialogAction(
    label: "Destructive",
    onPressed: () {},
  );

  return BisonDialog(
    title: "Basic dialog title",
    body: message,
    primaryAction: primary,
    secondaryAction: secondary,
    destructiveAction: destructive,
  );
}

@widgetbook.UseCase(name: 'Trigger Dialog', type: BisonDialog)
Widget builBisonDialogTrigger(BuildContext context) {
  final String message =
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat.";
  return BisonButton.filled(
    buttonLabel: "Open Dialog",
    onPressed: () {
      BisonDialog.show(
        context: context,
        title: 'Dialog',
        body: message,
        primaryAction: BisonDialogAction(label: 'Okay', onPressed: () {}),
        secondaryAction: BisonDialogAction(label: 'Cancel', onPressed: () {}),
        destructiveAction: BisonDialogAction(
          label: 'Destroy',
          onPressed: () {},
        ),
      );
    },
  );
}
