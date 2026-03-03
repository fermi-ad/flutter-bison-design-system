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

ButtonStyle getButtonStyle(
  final BuildContext context,
  final FilledButton button,
) {
  final ButtonStyle widgetStyle = button.style ?? const ButtonStyle();
  final ButtonStyle? themeStyle = button.themeStyleOf(context);
  final ButtonStyle defaults = button.defaultStyleOf(context);
  return widgetStyle.merge(themeStyle).merge(defaults);
}

MenuStyle getMenuStyle(
  final BuildContext context,
  final MenuAnchor menuAnchor,
) {
  final MenuStyle widgetStyle = menuAnchor.style ?? const MenuStyle();
  final MenuStyle? themeStyle = MenuTheme.of(context).style;
  return widgetStyle.merge(themeStyle);
}

ButtonStyle getMenuItemButtonStyle(
  final BuildContext context,
  final MenuItemButton menuItem,
) {
  final ButtonStyle widgetStyle = menuItem.style ?? const ButtonStyle();
  final ButtonStyle? themeStyle = menuItem.themeStyleOf(context);
  final ButtonStyle defaults = menuItem.defaultStyleOf(context);
  return widgetStyle.merge(themeStyle).merge(defaults);
}
