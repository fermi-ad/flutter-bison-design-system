import 'package:bison_design_system/bison_design_system.dart'
    show
        BisonThemeTokens,
        BisonSpacingTokens,
        BisonCornerTokens,
        BisonTypographyTokens;
import 'package:flutter/material.dart';

enum _BisonIconButtonType { filled, ghost, whiteGhost, smallGhost, outlined }

class BisonIconButton extends StatelessWidget {
  final Icon icon;
  final VoidCallback? onPressed;
  final _BisonIconButtonType _bisonIconButtonType;

  /// An icon button with a filled background.
  factory BisonIconButton.filled({
    required final Icon icon,
    required final VoidCallback? onPressed,
  }) {
    return BisonIconButton._(
      icon: icon,
      onPressed: onPressed,
      type: _BisonIconButtonType.filled,
    );
  }

  /// An icon button with a transparent background.
  ///
  ///
  factory BisonIconButton.ghost({
    required final Icon icon,
    required final VoidCallback? onPressed,
  }) {
    return BisonIconButton._(
      icon: icon,
      onPressed: onPressed,
      type: _BisonIconButtonType.ghost,
    );
  }

  /// An icon button with a transparent background and fixed white icon color.
  ///
  /// It is recommended to use with dark background.
  factory BisonIconButton.whiteGhost({
    required final Icon icon,
    required final VoidCallback? onPressed,
  }) {
    return BisonIconButton._(
      icon: icon,
      onPressed: onPressed,
      type: _BisonIconButtonType.whiteGhost,
    );
  }

  /// An icon button with a transparent background and zero padding.
  factory BisonIconButton.smallGhost({
    required final Icon icon,
    required final VoidCallback? onPressed,
  }) {
    return BisonIconButton._(
      icon: icon,
      onPressed: onPressed,
      type: _BisonIconButtonType.smallGhost,
    );
  }

  /// An icon button with a transparent background and outline
  factory BisonIconButton.outlined({
    required final Icon icon,
    required final VoidCallback? onPressed,
  }) {
    return BisonIconButton._(
      icon: icon,
      onPressed: onPressed,
      type: _BisonIconButtonType.outlined,
    );
  }

  const BisonIconButton._({
    required this.icon,
    required this.onPressed,
    required final _BisonIconButtonType type,
  }) : _bisonIconButtonType = type;

  @override
  Widget build(final BuildContext context) {
    final theme = Theme.of(context).extension<BisonThemeTokens>()!;
    final padding = Theme.of(context).extension<BisonSpacingTokens>()!;
    final corners = Theme.of(context).extension<BisonCornerTokens>()!;
    final typo = Theme.of(context).extension<BisonTypographyTokens>()!;
    return IconButton(
      onPressed: onPressed,
      constraints: const BoxConstraints(), // allows for smaller buttons
      icon: icon,
      iconSize: 24.0,
      style: switch (_bisonIconButtonType) {
        _BisonIconButtonType.filled => _filledButtonStyle(
          theme,
          padding,
          corners,
          typo,
        ),
        _BisonIconButtonType.ghost => _ghostButtonStyle(
          theme,
          padding,
          corners,
          typo,
        ),
        _BisonIconButtonType.whiteGhost => _whiteGhostButtonStyle(
          theme,
          padding,
          corners,
          typo,
        ),
        _BisonIconButtonType.smallGhost => _smallGhostButtonStyle(
          theme,
          padding,
          corners,
          typo,
        ),
        _BisonIconButtonType.outlined => _outlinedButtonStyle(
          theme,
          padding,
          corners,
          typo,
        ),
      },
    );
  }
}

ButtonStyle _filledButtonStyle(
  final BisonThemeTokens theme,
  final BisonSpacingTokens padding,
  final BisonCornerTokens corners,
  final BisonTypographyTokens typo,
) {
  return ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith<Color?>((
      final Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.disabled)) {
        return theme.surfaceTransparent;
      }
      if (states.contains(WidgetState.focused) ||
          states.contains(WidgetState.pressed)) {
        return theme.buttonPrimaryFocusedPressed;
      }
      if (states.contains(WidgetState.hovered)) {
        return theme.buttonPrimaryHovered;
      }
      return theme.buttonPrimary;
    }),
    foregroundColor: WidgetStateProperty.resolveWith<Color?>((
      final Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.disabled)) {
        return theme.iconDisabled;
      }
      if (states.contains(WidgetState.focused) ||
          states.contains(WidgetState.pressed)) {
        return theme.iconPrimary;
      }
      return theme.iconInverse;
    }),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(corners.cornerExtraSmall),
        ),
      ),
    ),
    side: WidgetStateProperty.resolveWith<BorderSide?>((
      final Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.disabled)) {
        return BorderSide(color: theme.borderDisabled, width: 2.0);
      }
      if (states.contains(WidgetState.focused)) {
        return BorderSide(color: theme.borderPrimary, width: 2.0);
      }
      return BorderSide(style: BorderStyle.none);
    }),
    // remove default padding given to button
    padding: WidgetStatePropertyAll(
      EdgeInsetsGeometry.all(padding.tinySpacing),
    ),
    // resetting default behaviour
    overlayColor: WidgetStatePropertyAll(theme.surfaceTransparent),
  );
}

ButtonStyle _ghostButtonStyle(
  final BisonThemeTokens theme,
  final BisonSpacingTokens padding,
  final BisonCornerTokens corners,
  final BisonTypographyTokens typo,
) {
  return ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith<Color?>((
      final Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.pressed)) {
        return theme.buttonGhostPressed;
      }
      if (states.contains(WidgetState.hovered)) {
        return theme.buttonGhostHovered;
      }
      return theme.surfaceTransparent;
    }),
    foregroundColor: WidgetStateProperty.resolveWith<Color?>((
      final Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.disabled)) {
        return theme.iconDisabled;
      }
      return theme.iconPlain;
    }),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(corners.cornerExtraSmall),
        ),
      ),
    ),
    side: WidgetStateProperty.resolveWith<BorderSide?>((
      final Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.focused)) {
        return BorderSide(color: theme.borderPrimary, width: 2.0);
      }
      return BorderSide(style: BorderStyle.none);
    }),
    // remove default padding given to button
    padding: WidgetStatePropertyAll(
      EdgeInsetsGeometry.all(padding.tinySpacing),
    ),
    // resetting default behaviour
    overlayColor: WidgetStatePropertyAll(theme.surfaceTransparent),
  );
}

ButtonStyle _whiteGhostButtonStyle(
  final BisonThemeTokens theme,
  final BisonSpacingTokens padding,
  final BisonCornerTokens corners,
  final BisonTypographyTokens typo,
) {
  return ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith<Color?>((
      final Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.pressed)) {
        return theme.buttonGhostWhiteFixedPressed;
      }
      if (states.contains(WidgetState.hovered)) {
        return theme.buttonGhostWhiteFixedHovered;
      }
      return theme.surfaceTransparent;
    }),
    foregroundColor: WidgetStateProperty.resolveWith<Color?>((
      final Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.disabled)) {
        return theme.iconDisabled;
      }
      return theme.iconWhiteFixed;
    }),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(corners.cornerExtraSmall),
        ),
      ),
    ),
    side: WidgetStateProperty.resolveWith<BorderSide?>((
      final Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.focused)) {
        return BorderSide(color: theme.borderPrimary, width: 2.0);
      }
      return BorderSide(style: BorderStyle.none);
    }),
    // remove default padding given to button
    padding: WidgetStatePropertyAll(
      EdgeInsetsGeometry.all(padding.tinySpacing),
    ),
    // resetting default behaviour
    overlayColor: WidgetStatePropertyAll(theme.surfaceTransparent),
  );
}

ButtonStyle _smallGhostButtonStyle(
  final BisonThemeTokens theme,
  final BisonSpacingTokens padding,
  final BisonCornerTokens corners,
  final BisonTypographyTokens typo,
) {
  return ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith<Color?>((
      final Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.pressed)) {
        return theme.buttonGhostPressed;
      }
      return theme.surfaceTransparent;
    }),
    foregroundColor: WidgetStateProperty.resolveWith<Color?>((
      final Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.disabled)) {
        return theme.iconDisabled;
      }
      if (states.contains(WidgetState.hovered) &&
          !states.contains(WidgetState.pressed)) {
        return theme.iconPrimary;
      }
      return theme.iconPlain;
    }),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(corners.cornerExtraSmall),
        ),
      ),
    ),
    side: WidgetStateProperty.resolveWith<BorderSide?>((
      final Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.focused)) {
        return BorderSide(color: theme.borderPrimary, width: 2.0);
      }
      return BorderSide(style: BorderStyle.none);
    }),
    // remove default padding given to button
    padding: WidgetStatePropertyAll(
      EdgeInsetsGeometry.all(padding.noneSpacing),
    ),
    // resetting default behaviour
    overlayColor: WidgetStatePropertyAll(theme.surfaceTransparent),
  );
}

ButtonStyle _outlinedButtonStyle(
  final BisonThemeTokens theme,
  final BisonSpacingTokens padding,
  final BisonCornerTokens corners,
  final BisonTypographyTokens typo,
) {
  return ButtonStyle(
    backgroundColor: WidgetStateProperty.resolveWith<Color?>((
      final Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.pressed)) {
        return theme.buttonGhostPressed;
      }
      if (states.contains(WidgetState.hovered)) {
        return theme.buttonGhostHovered;
      }
      return theme.surfaceTransparent;
    }),
    foregroundColor: WidgetStateProperty.resolveWith<Color?>((
      final Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.disabled)) {
        return theme.iconDisabled;
      }
      return theme.iconPrimary;
    }),
    shape: WidgetStateProperty.all(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.all(
          Radius.circular(corners.cornerExtraSmall),
        ),
      ),
    ),
    side: WidgetStateProperty.resolveWith<BorderSide?>((
      final Set<WidgetState> states,
    ) {
      if (states.contains(WidgetState.focused)) {
        return BorderSide(color: theme.borderPrimary, width: 2.0);
      }
      return BorderSide(color: theme.borderPlain, width: 2.0);
    }),
    // remove default padding given to button
    padding: WidgetStatePropertyAll(
      EdgeInsetsGeometry.all(padding.tinySpacing),
    ),
    // resetting default behaviour
    overlayColor: WidgetStatePropertyAll(theme.surfaceTransparent),
  );
}
