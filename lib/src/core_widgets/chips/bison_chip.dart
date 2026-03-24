import 'package:flutter/widgets.dart';
import 'package:flutter/material.dart' show Theme;
import 'package:bison_design_system/theme.dart'
    show
        BisonCornerTokens,
        BisonSpacingTokens,
        BisonThemeTokens,
        BisonTypographyTokens;

enum ObjectChipStyle { normal, warning, danger }

enum _ChipType { filter, input, suggestion, object }

class _ChipPalette {
  final Color active;
  final Color disabled;
  final Color hovered;
  final Color focuseDraggedPressed;

  const _ChipPalette({
    required this.active,
    required this.disabled,
    required this.hovered,
    required this.focuseDraggedPressed,
  });
}

class BisonChip extends StatefulWidget {
  final String label;
  final VoidCallback? onLeftPressed;
  final VoidCallback? onRightPressed;
  final Icon? leftIcon;
  final Icon? rightIcon;
  final bool selected;
  final bool enabled;
  final _ChipType _chipType;
  final ObjectChipStyle? _objectChipStyle;

  const BisonChip.filter({
    super.key,
    required this.label,
    this.onLeftPressed,
    this.onRightPressed,
    this.leftIcon,
    this.rightIcon,
    this.selected = false,
    this.enabled = true,
  }) : _chipType = _ChipType.filter,
       _objectChipStyle = null;

  const BisonChip.input({
    super.key,
    required this.label,
    this.onLeftPressed,
    this.onRightPressed,
    this.leftIcon,
    this.rightIcon,
    this.selected = false,
    this.enabled = true,
  }) : _chipType = _ChipType.input,
       _objectChipStyle = null;

  const BisonChip.suggestion({
    super.key,
    required this.label,
    this.onLeftPressed,
    this.onRightPressed,
    this.leftIcon,
    this.rightIcon,
    this.selected = false,
    this.enabled = true,
  }) : _chipType = _ChipType.suggestion,
       _objectChipStyle = null;

  const BisonChip.object({
    super.key,
    required this.label,
    this.onLeftPressed,
    this.onRightPressed,
    this.leftIcon,
    this.rightIcon,
    this.selected = false, // TODO: Not sure I need this yet
    this.enabled = true,
    ObjectChipStyle objectChipStyle = ObjectChipStyle.normal,
  }) : _chipType = _ChipType.object,
       _objectChipStyle = objectChipStyle;

  @override
  State<BisonChip> createState() => _BisonChipState();
}

class _BisonChipState extends State<BisonChip> {
  bool _isHovered = false;
  bool _isFocused = false;
  bool _isPressed = false;
  bool _isDragged = false;

  Set<WidgetState> get _states {
    final states = <WidgetState>{};
    if (!widget.enabled) states.add(WidgetState.disabled);
    if (_isHovered) states.add(WidgetState.hovered);
    if (_isFocused) states.add(WidgetState.focused);
    if (_isPressed) states.add(WidgetState.pressed);
    if (_isDragged) states.add(WidgetState.dragged);
    return states;
  }

  _ChipPalette _palette(final BisonThemeTokens theme) {
    switch (widget._chipType) {
      case _ChipType.filter:
        return _ChipPalette(
          // TODO: Add unselected states
          active: theme.chipSelectedActive,
          hovered: theme.chipSelectedHovered,
          focuseDraggedPressed: theme.chipSelectedFocusedDraggedPressed,
          disabled: theme.chipSelectedDisabled,
        );
      case _ChipType.input:
        return _ChipPalette(
          // TODO: Add unselected states
          active: theme.chipSelectedActive,
          hovered: theme.chipSelectedHovered,
          focuseDraggedPressed: theme.chipCautionFocusedDraggedPressed,
          // FIXME: Input chips do not have a disabled state
          disabled: theme.chipCautionDisabled,
        );
      case _ChipType.suggestion:
        return _ChipPalette(
          // TODO: Add unselected states
          active: theme.chipSelectedActive,
          hovered: theme.chipSelectedHovered,
          focuseDraggedPressed: theme.chipSelectedFocusedDraggedPressed,
          disabled: theme.chipSelectedDisabled,
        );
      case _ChipType.object:
        switch (widget._objectChipStyle ?? ObjectChipStyle.normal) {
          case ObjectChipStyle.normal:
            return _ChipPalette(
              active: theme.chipUnselectedActive,
              hovered: theme.chipUnselectedHovered,
              focuseDraggedPressed: theme.chipUnselectedFocusedDraggedPressed,
              disabled: theme.surfaceTransparent,
            );
          case ObjectChipStyle.warning:
            return _ChipPalette(
              active: theme.chipWarningActive,
              hovered: theme.chipWarningHovered,
              focuseDraggedPressed: theme.chipWarningFocusedDraggedPressed,
              disabled: theme.chipWarningDisabled,
            );
          case ObjectChipStyle.danger:
            return _ChipPalette(
              active: theme.chipDangerActive,
              hovered: theme.chipDangerHovered,
              focuseDraggedPressed: theme.chipDangerFocusedDraggedPressed,
              disabled: theme.chipDangerDisabled,
            );
        }
    }
  }

  Color _backgroundColor(final BisonThemeTokens theme) {
    final palette = _palette(theme);
    if (_states.contains(WidgetState.disabled)) return palette.disabled;
    if (_states.contains(WidgetState.focused) &&
        !_states.contains(WidgetState.hovered) &&
        !_states.contains(WidgetState.pressed) &&
        !_states.contains(WidgetState.dragged)) {
      return palette.focuseDraggedPressed;
    }
    if (_states.contains(WidgetState.dragged) ||
        _states.contains(WidgetState.pressed)) {
      return palette.focuseDraggedPressed;
    }
    if (_states.contains(WidgetState.hovered)) return palette.hovered;
    return palette.active;
  }

  Color _foregroundColor(final BisonThemeTokens theme) {
    if (_states.contains(WidgetState.disabled)) return theme.textDisabled;
    return theme.textPlain;
  }

  Color _borderColor(final BisonThemeTokens theme) {
    if (_states.contains(WidgetState.focused)) return theme.borderPrimary;
    return theme.borderPlain;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context).extension<BisonThemeTokens>()!;
    final spacing = Theme.of(context).extension<BisonSpacingTokens>()!;
    final corners = Theme.of(context).extension<BisonCornerTokens>()!;
    final typography = Theme.of(context).extension<BisonTypographyTokens>()!;

    Widget buildBisonChip() {
      return Container(
        decoration: BoxDecoration(
          color: _backgroundColor(theme),
          border: Border.all(color: _borderColor(theme)),
          borderRadius: BorderRadius.circular(corners.cornerExtraSmall),
        ),
        padding: EdgeInsets.symmetric(
          vertical: spacing.microSpacing,
          horizontal: spacing.tinySpacing,
        ),
        child: IconTheme(
          data: IconThemeData(color: _foregroundColor(theme)),
          child: DefaultTextStyle(
            style: typography.bodySmall.copyWith(
              color: _foregroundColor(theme),
            ),
            child: Row(
              mainAxisSize: .min,
              children: [
                if (widget.leftIcon != null) ...[
                  widget.leftIcon!,
                  SizedBox(width: spacing.tinySpacing),
                ],
                Text(widget.label),
                if (widget.rightIcon != null) ...[
                  SizedBox(width: spacing.tinySpacing),
                  widget.rightIcon!,
                ],
              ],
            ),
          ),
        ),
      );
    }

    return FocusableActionDetector(
      enabled: widget.enabled,
      mouseCursor: widget.enabled
          ? SystemMouseCursors.click
          : SystemMouseCursors.basic,
      onShowFocusHighlight: (final value) {
        setState(() => _isFocused = value);
      },
      onFocusChange: (final isFocused) {
        if (!isFocused) {
          setState(() => _isHovered = false);
        }
      },
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() {
          _isHovered = false;
          _isPressed = false;
        }),
        child: GestureDetector(
          onTapDown: widget.enabled
              ? (_) => setState(() => _isPressed = true)
              : null,
          onTapUp: widget.enabled
              ? (_) => setState(() => _isPressed = false)
              : null,
          onTapCancel: widget.enabled
              ? () => setState(() => _isPressed = false)
              : null,
          onPanStart: widget.enabled
              ? (_) => setState(() => _isDragged = true)
              : null,
          onPanCancel: widget.enabled
              ? () => setState(() => _isDragged = false)
              : null,
          onPanEnd: widget.enabled
              ? (_) => setState(() => _isDragged = false)
              : null,
          onTap: widget.enabled ? widget.onLeftPressed : null,
          onSecondaryTap: widget.enabled ? widget.onRightPressed : null,
          child: buildBisonChip(),
        ),
      ),
    );
  }
}
