import 'package:flutter/material.dart';
import 'package:widgetbook/widgetbook.dart' show KnobsExtension;
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:bison_design_system/core_widgets.dart'
    show BisonCard, BisonMenuItem;

@widgetbook.UseCase(name: 'Default', type: BisonCard)
Widget buildBisonCardUseCase(BuildContext context) {
  final headerText = context.knobs.string(
    label: 'Header Text',
    initialValue: 'Header',
  );

  final subheadText = context.knobs.string(
    label: 'Subhead Text',
    initialValue: 'Subhead',
  );

  final title = context.knobs.string(
    label: 'Title',
    initialValue: 'Card Title',
  );

  final subtitle = context.knobs.string(
    label: 'Subtitle',
    initialValue: 'Card Subtitle',
  );

  final supportingText = context.knobs.string(
    label: 'Supporting Text',
    initialValue:
        'This is supporting text that provides additional context about the card content.',
  );

  final primaryLabel = context.knobs.string(
    label: 'Primary Action Label',
    initialValue: 'Action',
  );

  final secondaryLabel = context.knobs.string(
    label: 'Secondary Action Label',
    initialValue: 'Cancel',
  );

  return BisonCard.stackedWithImage(
    avatar: const CircleAvatar(child: Text('A')),
    headerText: headerText,
    subheadText: subheadText,
    menuItems: [
      BisonMenuItem(label: 'Edit', onSelect: () {}),
      BisonMenuItem(label: 'Delete', onSelect: () {}),
    ],
    media: Container(color: Colors.blueGrey),
    title: title,
    subtitle: subtitle,
    supportingText: supportingText,
    primaryAction: TextButton(onPressed: () {}, child: Text(primaryLabel)),
    secondaryAction: TextButton(onPressed: () {}, child: Text(secondaryLabel)),
  );
}

@widgetbook.UseCase(name: 'Horizontal with Image', type: BisonCard)
Widget buildBisonCardHorizontalUseCase(BuildContext context) {
  final headerText = context.knobs.string(
    label: 'Header Text',
    initialValue: 'Header',
  );

  final subheadText = context.knobs.string(
    label: 'Subhead Text',
    initialValue: 'Subhead',
  );

  return BisonCard.horizontalWithImage(
    avatar: const CircleAvatar(child: Text('B')),
    headerText: headerText,
    subheadText: subheadText,
    media: Container(color: Colors.blueGrey),
  );
}
