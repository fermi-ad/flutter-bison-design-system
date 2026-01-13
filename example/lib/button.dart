import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

import 'package:design_system/core_widgets.dart';

@widgetbook.UseCase(name: 'Default', type: Button)
Widget buildCoolButtonUseCase(BuildContext context) {
  return Button();
}
