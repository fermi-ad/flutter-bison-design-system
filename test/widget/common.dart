import 'package:flutter/material.dart';
import 'package:bison_design_system/bison_design_system.dart'
    show BisonThemeData;

/// Helper to build a minimal app with the given widget as the body.
Widget buildScaffold(final Widget widget) {
  return MaterialApp(
    theme: BisonThemeData.light(),
    home: Scaffold(body: Center(child: widget)),
  );
}

ButtonStyle _mergeButtonStyles(
  final ButtonStyle? widgetStyle,
  final ButtonStyle? themeStyle,
  final ButtonStyle defaults,
) {
  return (widgetStyle ?? const ButtonStyle()).merge(themeStyle).merge(defaults);
}

ButtonStyle getButtonStyle(
  final BuildContext context,
  final ButtonStyleButton button,
) {
  return _mergeButtonStyles(
    button.style,
    // ButtonStyleButton is abstract, so you can only ever pass instances of
    // its subclasses which must override these methods.
    // ignore: invalid_use_of_protected_member
    button.themeStyleOf(context),
    // ignore: invalid_use_of_protected_member
    button.defaultStyleOf(context),
  );
}

ButtonStyle getMenuItemButtonStyle(
  final BuildContext context,
  final MenuItemButton menuItem,
) {
  return _mergeButtonStyles(
    menuItem.style,
    menuItem.themeStyleOf(context),
    menuItem.defaultStyleOf(context),
  );
}

ButtonStyle getIconButtonStyle(
  final BuildContext context,
  final IconButton button,
) {
  final ButtonStyle widgetStyle = button.style ?? const ButtonStyle();
  final ButtonStyle? themeStyle = IconButtonTheme.of(context).style;
  return widgetStyle.merge(themeStyle);
}

MenuStyle getMenuStyle(
  final BuildContext context,
  final MenuAnchor menuAnchor,
) {
  final MenuStyle widgetStyle = menuAnchor.style ?? const MenuStyle();
  final MenuStyle? themeStyle = MenuTheme.of(context).style;
  return widgetStyle.merge(themeStyle);
}
