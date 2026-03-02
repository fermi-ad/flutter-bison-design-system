import 'package:flutter/material.dart';
import 'package:bison_design_system/bison_design_system.dart'
    show BisonThemeData;

// Helper to build a minimal app with the given widget as the body.
Widget buildScaffold(final Widget widget) {
  return MaterialApp(
    theme: BisonThemeData.light(),
    home: Scaffold(body: Center(child: widget)),
  );
}
