import 'package:flutter/widgets.dart';
import 'package:bison_design_system/theme.dart'
    show BisonContext, BisonSpacingTokens, BisonThemeTokens;

/// Controls the size of [BisonTextField]'s input area.
enum BisonTextFieldSize {
  /// 48px input height with [BisonSpacingTokens.smallSpacing] padding on all
  /// sides.
  large,

  /// 40px input height with tiny vertical and small horizontal padding.
  medium,

  /// 32px input height with tiny vertical and small horizontal padding.
  small,
}

/// A text field widget for the Bison design system.
///
/// Built on [EditableText] with no dependency on the Material library.
///
/// Supports an optional [label] displayed above the input and optional
/// [helperText] displayed below. Visual state (border color, background)
/// adapts to disabled, error, warning, focused, hovered, and default states.
///
/// State ownership:
/// - When [controller] is provided, text state is owned by the caller and can
///   persist across remounts.
/// - When [controller] is omitted, this widget creates an internal controller.
///   Text is preserved across normal rebuilds of the same mounted element, but
///   is not restored after remounts.
///
/// ```dart
/// BisonTextField(
///   label: 'Email',
///   placeholder: 'you@example.com',
///   helperText: 'We will never share your email.',
/// )
/// ```
class BisonTextField extends StatefulWidget {
  /// Label displayed above the input field.
  final String? label;

  /// Helper text displayed below the input field. It can be used
  /// for more information on error/warning states
  final String? helperText;

  /// Placeholder text shown inside the field when it is empty.
  final String? placeholder;

  /// Controls the text being edited.
  ///
  /// If not provided, an internal controller is created and managed by the
  /// widget.
  ///
  /// Provide a controller when the text must be preserved across remounts.
  final TextEditingController? controller;

  /// Controls whether this widget has keyboard focus.
  ///
  /// If not provided, an internal [FocusNode] is created and managed by the
  /// widget.
  final FocusNode? focusNode;

  /// Whether the text field is interactive.
  ///
  /// Defaults to `true`. When `false`, the field ignores pointer events and
  /// renders with disabled styling.
  final bool enabled;

  /// Whether the field is in an error state.
  ///
  /// When `true`, the border uses `borderError` and [helperText] (if any) is
  /// rendered in `textError`. Takes precedence over [hasWarning].
  final bool hasError;

  /// Whether the field is in a warning state.
  ///
  /// When `true`, the border uses `borderWarning`. Ignored when [hasError] is
  /// also `true`.
  final bool hasWarning;

  /// Called whenever the text changes.
  final ValueChanged<String>? onChanged;

  /// Whether the field should request focus as soon as it is mounted.
  ///
  /// `false` by default.
  final bool autofocus;

  /// The type of keyboard to display for editing.
  final TextInputType? keyboardType;

  /// Whether to obscure the text, e.g. for password fields.
  final bool obscureText;

  /// The overall size of the input area.
  ///
  /// Defaults to [BisonTextFieldSize.medium].
  final BisonTextFieldSize size;

  const BisonTextField({
    super.key,
    this.label,
    this.helperText,
    this.placeholder,
    this.controller,
    this.focusNode,
    this.enabled = true,
    this.hasError = false,
    this.hasWarning = false,
    this.onChanged,
    this.autofocus = false,
    this.keyboardType,
    this.obscureText = false,
    this.size = BisonTextFieldSize.medium,
  });

  @override
  State<BisonTextField> createState() => _BisonTextFieldState();
}

/// Holds the hover + focus interaction state and notifies listeners on change.
///
/// Using a dedicated [ChangeNotifier] lets us rebuild only the container
/// decoration without touching [_InputArea], which would cause [EditableText]
/// to lose focus.
class _InteractionState extends ChangeNotifier {
  bool _isHovered = false;
  bool _isFocused = false;

  bool get isHovered => _isHovered;
  bool get isFocused => _isFocused;

  set isHovered(final bool value) {
    if (_isHovered == value) return;
    _isHovered = value;
    notifyListeners();
  }

  set isFocused(final bool value) {
    if (_isFocused == value) return;
    _isFocused = value;
    notifyListeners();
  }
}

class _BisonTextFieldState extends State<BisonTextField> {
  late TextEditingController _controller;
  late FocusNode _focusNode;
  final _InteractionState _interaction = _InteractionState();

  bool _ownsController = false;
  bool _ownsFocusNode = false;

  @override
  void initState() {
    super.initState();

    if (widget.controller == null) {
      _controller = TextEditingController();
      _ownsController = true;
    } else {
      _controller = widget.controller!;
    }

    if (widget.focusNode == null) {
      _focusNode = FocusNode();
      _ownsFocusNode = true;
    } else {
      _focusNode = widget.focusNode!;
    }

    _focusNode.addListener(_onFocusChanged);
  }

  @override
  void didUpdateWidget(covariant BisonTextField oldWidget) {
    super.didUpdateWidget(oldWidget);

    // Controller swap
    if (widget.controller != oldWidget.controller) {
      if (_ownsController) {
        _controller.dispose();
      }
      if (widget.controller == null) {
        _controller = TextEditingController();
        _ownsController = true;
      } else {
        _controller = widget.controller!;
        _ownsController = false;
      }
    }

    // FocusNode swap
    if (widget.focusNode != oldWidget.focusNode) {
      _focusNode.removeListener(_onFocusChanged);
      if (_ownsFocusNode) {
        _focusNode.dispose();
      }
      if (widget.focusNode == null) {
        _focusNode = FocusNode();
        _ownsFocusNode = true;
      } else {
        _focusNode = widget.focusNode!;
        _ownsFocusNode = false;
      }
      _focusNode.addListener(_onFocusChanged);
    }
  }

  @override
  void dispose() {
    _focusNode.removeListener(_onFocusChanged);
    _interaction.dispose();
    if (_ownsController) {
      _controller.dispose();
    }
    if (_ownsFocusNode) _focusNode.dispose();
    super.dispose();
  }

  void _onFocusChanged() {
    _interaction.isFocused = _focusNode.hasFocus;
  }

  // ── Color resolution ──────────────────────────────────────────────────────

  /// State priority: disabled > error > warning > focused > hovered > default
  Color _backgroundColor(final BisonThemeTokens theme) {
    if (!widget.enabled) return theme.inputFieldFieldDisabled;
    if (_interaction.isHovered && !_interaction.isFocused) {
      return theme.inputFieldFieldHovered;
    }
    return theme.inputFieldField;
  }

  /// Returns the [BisonTextFieldBorderSpec] describing the border for the
  /// current state.
  ///
  /// A consistent 2px border width is always reserved on all sides to prevent
  /// layout shifts when transitioning between states. The spec is consumed by
  /// [BisonTextFieldBorderPainter] which draws the border with the correct
  /// rounded top corners via [Canvas], bypassing Flutter's [BoxDecoration]
  /// constraint that forbids non-uniform side colors when borderRadius is set.
  BisonTextFieldBorderSpec _borderSpec(final BisonThemeTokens theme) {
    if (!widget.enabled) {
      return BisonTextFieldBorderSpec.bottomOnly(theme.borderDisabled);
    }
    if (widget.hasError) {
      return BisonTextFieldBorderSpec.all(theme.borderError);
    }
    if (widget.hasWarning) {
      return BisonTextFieldBorderSpec.all(theme.borderWarning);
    }
    if (_interaction.isFocused) {
      return BisonTextFieldBorderSpec.all(theme.borderPrimary);
    }
    return BisonTextFieldBorderSpec.bottomOnly(theme.borderPlain);
  }

  Color _helperTextColor(final BisonThemeTokens theme) {
    if (!widget.enabled) return theme.textDisabled;
    if (widget.hasError) return theme.textError;
    if (widget.hasWarning) return theme.textPlain;
    return theme.textMuted;
  }

  Color _labelColor(final BisonThemeTokens theme) {
    if (!widget.enabled) return theme.textDisabled;
    return theme.textMuted;
  }

  double _inputHeight() {
    switch (widget.size) {
      case BisonTextFieldSize.large:
        return 48;
      case BisonTextFieldSize.medium:
        return 40;
      case BisonTextFieldSize.small:
        return 32;
    }
  }

  EdgeInsets _inputPadding(final BisonSpacingTokens spacing) {
    switch (widget.size) {
      case BisonTextFieldSize.large:
        return EdgeInsets.all(spacing.smallSpacing);
      case BisonTextFieldSize.medium:
      case BisonTextFieldSize.small:
        return EdgeInsets.symmetric(
          vertical: spacing.tinySpacing,
          horizontal: spacing.smallSpacing,
        );
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(final BuildContext context) {
    final bison = context.bison;
    final theme = bison.theme;
    final spacing = bison.spacing;
    final corners = bison.corners;
    final typography = bison.typography;
    final double inputHeight = _inputHeight();
    final EdgeInsets inputPadding = _inputPadding(spacing);

    // _InputArea is a StatefulWidget so its element — and the EditableText
    // element inside it — survive rebuilds of _BisonTextFieldState triggered
    // by _interaction notifications.
    //
    // Theme and typography are NOT passed as props to avoid triggering
    // _InputAreaState rebuilds on every parent build (theme objects are
    // recreated each time). Instead _InputAreaState resolves them from context.
    final Widget inputArea = _InputArea(
      controller: _controller,
      focusNode: _focusNode,
      placeholder: widget.placeholder,
      enabled: widget.enabled,
      autofocus: widget.autofocus,
      keyboardType: widget.keyboardType,
      obscureText: widget.obscureText,
      onChanged: widget.onChanged,
    );

    // ListenableBuilder watches only _interaction so the decoration updates on
    // hover/focus without rebuilding inputArea.
    //
    // Layout-shift fix: a consistent 2px border is always reserved on all sides
    // so no shift occurs when transitioning between states (e.g. default →
    // focused). The border is drawn by [BisonTextFieldBorderPainter] via
    // [CustomPaint] so it can have rounded top corners and non-uniform side
    // colors without hitting Flutter's BoxDecoration constraint.
    final borderRadius = BorderRadius.only(
      topLeft: Radius.circular(corners.cornerExtraSmall),
      topRight: Radius.circular(corners.cornerExtraSmall),
    );
    final Widget inputContainer = ListenableBuilder(
      listenable: _interaction,
      builder: (final BuildContext ctx, final Widget? child) {
        return SizedBox(
          height: inputHeight,
          child: CustomPaint(
            foregroundPainter: BisonTextFieldBorderPainter(
              spec: _borderSpec(theme),
              borderRadius: borderRadius,
            ),
            child: Container(
              decoration: BoxDecoration(
                color: _backgroundColor(theme),
                borderRadius: borderRadius,
              ),
              padding: inputPadding,
              child: child,
            ),
          ),
        );
      },
      child: inputArea,
    );

    // TapRegion at the BisonTextField level handles tap-outside reliably.
    // The GestureDetector inside the TapRegion focuses the field when the
    // padding area (outside EditableText's hit area) is tapped.
    final Widget interactiveContainer = TapRegion(
      onTapOutside: widget.enabled ? (_) => _focusNode.unfocus() : null,
      child: MouseRegion(
        cursor: widget.enabled
            ? SystemMouseCursors.text
            : SystemMouseCursors.basic,
        onEnter: widget.enabled ? (_) => _interaction.isHovered = true : null,
        onExit: widget.enabled ? (_) => _interaction.isHovered = false : null,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: widget.enabled ? () => _focusNode.requestFocus() : null,
          child: inputContainer,
        ),
      ),
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: typography.capitalizedLabel.copyWith(
              color: _labelColor(theme),
            ),
          ),
          SizedBox(height: spacing.tinySpacing),
        ],
        interactiveContainer,
        if (widget.helperText != null) ...[
          SizedBox(height: spacing.microSpacing),
          Text(
            widget.helperText!,
            style: typography.bodySmall.copyWith(
              color: _helperTextColor(theme),
            ),
          ),
        ],
      ],
    );
  }
}

// ── Private input area widget ─────────────────────────────────────────────────

/// Owns the [EditableText] and placeholder overlay.
///
/// This must be a [StatefulWidget] so that Flutter preserves its element
/// across rebuilds of the parent [_BisonTextFieldState].
///
/// Theme and typography tokens are resolved from [BuildContext] inside
/// [_InputAreaState.build] rather than passed as constructor props. This
/// prevents [_InputAreaState] from rebuilding [EditableText] every time the
/// parent rebuilds (which would happen because token objects are recreated on
/// each parent [build] call, making them always "new" by identity).
class _InputArea extends StatefulWidget {
  final TextEditingController controller;
  final FocusNode focusNode;
  final String? placeholder;
  final bool enabled;
  final bool autofocus;
  final TextInputType? keyboardType;
  final bool obscureText;
  final ValueChanged<String>? onChanged;

  const _InputArea({
    required this.controller,
    required this.focusNode,
    required this.placeholder,
    required this.enabled,
    required this.autofocus,
    required this.keyboardType,
    required this.obscureText,
    required this.onChanged,
  });

  @override
  State<_InputArea> createState() => _InputAreaState();
}

class _InputAreaState extends State<_InputArea> {
  @override
  Widget build(final BuildContext context) {
    final bison = context.bison;
    final theme = bison.theme;
    final typography = bison.typography;

    final Color textColor = widget.enabled
        ? theme.textPlain
        : theme.textDisabled;
    final Color placeholderColor = widget.enabled
        ? theme.textMuted
        : theme.textDisabled;

    final Widget editableText = IgnorePointer(
      ignoring: !widget.enabled,
      child: EditableText(
        controller: widget.controller,
        focusNode: widget.focusNode,
        style: typography.bodyLarge.copyWith(color: textColor),
        cursorColor: theme.borderPrimary,
        backgroundCursorColor: theme.textDisabled,
        selectionColor: theme.borderPrimary.withValues(alpha: 0.3),
        autofocus: widget.autofocus,
        readOnly: !widget.enabled,
        keyboardType: widget.keyboardType,
        obscureText: widget.obscureText,
        onChanged: widget.onChanged,
        cursorWidth: 2.0,
        cursorRadius: const Radius.circular(1.0),
      ),
    );

    if (widget.placeholder == null) return editableText;

    // Placeholder: ValueListenableBuilder watches the controller so only the
    // Visibility widget updates. The Stack always has exactly two children at
    // fixed indices so EditableText is never remounted when the placeholder
    // toggles.
    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: widget.controller,
      builder:
          (
            final BuildContext ctx,
            final TextEditingValue value,
            final Widget? child,
          ) {
            return Stack(
              alignment: Alignment.centerLeft,
              children: [
                Visibility(
                  visible: value.text.isEmpty,
                  child: IgnorePointer(
                    child: Text(
                      widget.placeholder!,
                      style: typography.bodyLarge.copyWith(
                        color: placeholderColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
                child!,
              ],
            );
          },
      child: editableText,
    );
  }
}

// ── Border painting helpers ───────────────────────────────────────────────────

/// Describes the border to draw around the input field.
///
/// [allColor] — when non-null, all four sides are drawn with this color.
/// [bottomColor] — when [allColor] is null, only the bottom side is drawn.
///
/// Exposed as a public class so widget tests can read the painter's spec via
/// `tester.widget<CustomPaint>(...)`.
class BisonTextFieldBorderSpec {
  final Color? allColor;
  final Color? bottomColor;

  const BisonTextFieldBorderSpec._({this.allColor, this.bottomColor});

  /// All four sides drawn with [color].
  const BisonTextFieldBorderSpec.all(final Color color)
    : this._(allColor: color);

  /// Only the bottom side drawn with [color]; other sides are transparent.
  const BisonTextFieldBorderSpec.bottomOnly(final Color color)
    : this._(bottomColor: color);

  @override
  bool operator ==(Object other) =>
      other is BisonTextFieldBorderSpec &&
      other.allColor == allColor &&
      other.bottomColor == bottomColor;

  @override
  int get hashCode => Object.hash(allColor, bottomColor);
}

/// Draws the input field border with rounded top corners via [Canvas].
///
/// Using a [CustomPainter] lets us:
///   1. Reserve a consistent 2px inset on all sides (no layout shift).
///   2. Draw rounded top corners on the border regardless of whether all sides
///      or only the bottom side are visible.
///   3. Avoid Flutter's [BoxDecoration] constraint that forbids non-uniform
///      border side colors when [borderRadius] is also set.
///
/// Exposed as a public class so widget tests can read the painter's spec via
/// `tester.widget<CustomPaint>(...)`.
class BisonTextFieldBorderPainter extends CustomPainter {
  final BisonTextFieldBorderSpec spec;
  final BorderRadius borderRadius;

  const BisonTextFieldBorderPainter({
    required this.spec,
    required this.borderRadius,
  });

  @override
  void paint(final Canvas canvas, final Size size) {
    const double w = 2.0; // border width
    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = w;

    // We inset by w/2 so the stroke is fully within the widget bounds.
    final double half = w / 2;
    final Rect rect = Rect.fromLTWH(
      half,
      half,
      size.width - w,
      size.height - w,
    );

    if (spec.allColor != null) {
      // Full border with rounded top corners.
      paint.color = spec.allColor!;
      final RRect rrect = borderRadius.toRRect(rect);
      canvas.drawRRect(rrect, paint);
    } else if (spec.bottomColor != null) {
      // Bottom-only border: draw a straight horizontal line at the bottom,
      // inset by [half] on each side so it aligns with the inner container.
      paint.color = spec.bottomColor!;
      canvas.drawLine(
        Offset(half, size.height - half),
        Offset(size.width - half, size.height - half),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(final BisonTextFieldBorderPainter oldDelegate) =>
      oldDelegate.spec != spec || oldDelegate.borderRadius != borderRadius;
}
