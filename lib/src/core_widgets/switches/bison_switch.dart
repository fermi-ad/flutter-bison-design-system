import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:bison_design_system/theme.dart'
    show BisonContext, BisonThemeTokens;

/// The two available sizes for a [BisonSwitch].
enum BisonSwitchSize {
  /// Default size: 48 × 24 px track.
  medium,

  /// Small size: 32 × 16 px track.
  small,
}

/// The visual/interactive variant of a [BisonSwitch].
enum BisonSwitchVariant {
  /// Interactive switch with default styling.
  normal,

  /// Non-interactive; uses disabled color tokens.
  disabled,

  /// Non-interactive; transparent background with a plain border.
  readOnly,

  /// Loading placeholder; renders skeleton shapes.
  skeleton,
}

// ---------------------------------------------------------------------------
// Internal size constants – not part of the design-token system but kept as
// named variables for easy tracking and future updates.
// ---------------------------------------------------------------------------
const double _defaultTrackWidth = 48.0;
const double _defaultTrackHeight = 24.0;
const double _defaultThumbDiameter = 18.0;

const double _smallTrackWidth = 32.0;
const double _smallTrackHeight = 16.0;
const double _smallThumbDiameter = 10.0;

const double _trackInnerPadding = 3.0;

// Focus-ring color specified in the design spec (not a named token).
const Color _focusRingColor = Color(0xFF0A30DA);

/// A toggle switch that follows the Bison design system.
///
/// ## Basic usage
/// ```dart
/// BisonSwitch(
///   value: _isOn,
///   onChanged: (v) => setState(() => _isOn = v),
/// )
/// ```
///
/// ## With label and state text
/// ```dart
/// BisonSwitch(
///   value: _isOn,
///   onChanged: (v) => setState(() => _isOn = v),
///   label: 'Notifications',
///   stateText: _isOn ? 'On' : 'Off',
/// )
/// ```
class BisonSwitch extends StatefulWidget {
  /// Whether the switch is currently toggled on.
  final bool value;

  /// Called when the user taps the switch (or activates it via keyboard).
  ///
  /// Pass `null` to make the switch non-interactive (equivalent to
  /// [BisonSwitchVariant.readOnly] or [BisonSwitchVariant.disabled]).
  final ValueChanged<bool>? onChanged;

  /// Optional label rendered above the switch.
  final String? label;

  /// Optional text rendered to the right of the switch.
  final String? stateText;

  /// Controls the track/thumb dimensions.
  final BisonSwitchSize size;

  /// Controls the visual and interactive behavior of the switch.
  final BisonSwitchVariant variant;

  /// An optional [FocusNode] to control focus externally.
  final FocusNode? focusNode;

  /// Whether the switch should request focus automatically.
  /// Defaults to false.
  final bool autofocus;

  const BisonSwitch({
    super.key,
    required this.value,
    this.onChanged,
    this.label,
    this.stateText,
    this.size = BisonSwitchSize.medium,
    this.variant = BisonSwitchVariant.normal,
    this.focusNode,
    this.autofocus = false,
  });

  @override
  State<BisonSwitch> createState() => _BisonSwitchState();
}

class _BisonSwitchState extends State<BisonSwitch> {
  bool _isFocused = false;

  // -------------------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------------------

  bool get _isInteractive =>
      widget.variant == BisonSwitchVariant.normal && widget.onChanged != null;

  double get _trackWidth => widget.size == BisonSwitchSize.medium
      ? _defaultTrackWidth
      : _smallTrackWidth;

  double get _trackHeight => widget.size == BisonSwitchSize.medium
      ? _defaultTrackHeight
      : _smallTrackHeight;

  double get _thumbDiameter => widget.size == BisonSwitchSize.medium
      ? _defaultThumbDiameter
      : _smallThumbDiameter;

  // -------------------------------------------------------------------------
  // Color resolution
  // -------------------------------------------------------------------------

  Color _trackColor(final BisonThemeTokens theme) {
    switch (widget.variant) {
      case BisonSwitchVariant.disabled:
        return theme.selectorSelectorSwitchFillDisabled;
      case BisonSwitchVariant.readOnly:
        return theme.surfaceTransparent;
      case BisonSwitchVariant.skeleton:
        return theme.miscellaneousSkeletonBackground;
      case BisonSwitchVariant.normal:
        return widget.value
            ? theme.selectorSelectorPrimary
            : theme.selectorSelectorSwitchFill;
    }
  }

  Color _thumbColor(final BisonThemeTokens theme) {
    switch (widget.variant) {
      case BisonSwitchVariant.disabled:
        return theme.selectorSelectorSwitchDisabled;
      case BisonSwitchVariant.readOnly:
        return theme.iconPlain;
      case BisonSwitchVariant.skeleton:
        return theme.miscellaneousSkeletonBackground;
      case BisonSwitchVariant.normal:
        return theme.selectorSelectorCheckboxCheck;
    }
  }

  Color _textColor(final BisonThemeTokens theme) {
    return widget.variant == BisonSwitchVariant.disabled
        ? theme.textDisabled
        : theme.textPlain;
  }

  // -------------------------------------------------------------------------
  // Toggle
  // -------------------------------------------------------------------------

  void _handleTap() {
    if (_isInteractive) {
      widget.onChanged!(!widget.value);
    }
  }

  // -------------------------------------------------------------------------
  // Build
  // -------------------------------------------------------------------------

  @override
  Widget build(final BuildContext context) {
    final bison = context.bison;

    if (widget.variant == BisonSwitchVariant.skeleton) {
      return _buildSkeleton(bison.theme, bison.spacing.tinySpacing);
    }

    final trackColor = _trackColor(bison.theme);
    final thumbColor = _thumbColor(bison.theme);
    final textColor = _textColor(bison.theme);
    final cornerRadius = _trackHeight / 2; // pill shape

    // Thumb alignment: right when 'on', left when 'off'.
    final thumbAlignment = widget.value
        ? Alignment.centerRight
        : Alignment.centerLeft;

    Widget track = AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      width: _trackWidth,
      height: _trackHeight,
      padding: const EdgeInsets.all(_trackInnerPadding),
      decoration: BoxDecoration(
        color: trackColor,
        borderRadius: BorderRadius.circular(cornerRadius),
        border: widget.variant == BisonSwitchVariant.readOnly
            ? Border.all(color: bison.theme.borderPlain, width: 1.0)
            : null,
        boxShadow: _isFocused && widget.variant == BisonSwitchVariant.normal
            ? const [
                BoxShadow(
                  color: _focusRingColor,
                  blurRadius: 0,
                  spreadRadius: 2,
                ),
              ]
            : null,
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 150),
        alignment: thumbAlignment,
        child: Container(
          width: _thumbDiameter,
          height: _thumbDiameter,
          decoration: BoxDecoration(color: thumbColor, shape: BoxShape.circle),
        ),
      ),
    );

    // Wrap in interaction handlers only for the normal interactive variant.
    if (_isInteractive) {
      track = FocusableActionDetector(
        focusNode: widget.focusNode,
        autofocus: widget.autofocus,
        mouseCursor: SystemMouseCursors.click,
        shortcuts: const <ShortcutActivator, Intent>{
          SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
          SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
        },
        actions: <Type, Action<Intent>>{
          ActivateIntent: CallbackAction<ActivateIntent>(
            onInvoke: (_) {
              _handleTap();
              return null;
            },
          ),
        },
        onShowFocusHighlight: (final value) {
          setState(() => _isFocused = value);
        },
        onFocusChange: (final isFocused) {
          if (!isFocused) setState(() => _isFocused = false);
        },
        child: GestureDetector(onTap: _handleTap, child: track),
      );
    }

    // Row: [track] [optional stateText]
    final Widget switchRow = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        track,
        if (widget.stateText != null) ...[
          SizedBox(width: bison.spacing.tinySpacing),
          Text(
            widget.stateText!,
            style: bison.typography.bodyLarge.copyWith(color: textColor),
          ),
        ],
      ],
    );

    // Column: [optional label] [switchRow]
    if (widget.label != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.label!,
            style: bison.typography.bodySmall.copyWith(color: textColor),
          ),
          SizedBox(height: bison.spacing.tinySpacing),
          switchRow,
        ],
      );
    }

    return switchRow;
  }

  // -------------------------------------------------------------------------
  // Skeleton
  // -------------------------------------------------------------------------

  Widget _buildSkeleton(
    final BisonThemeTokens theme,
    final double tinySpacing,
  ) {
    final skeletonColor = theme.miscellaneousSkeletonBackground;

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Circular track skeleton
        Container(
          width: _trackWidth,
          height: _trackHeight,
          decoration: BoxDecoration(
            color: skeletonColor,
            shape: BoxShape.circle,
          ),
        ),
        SizedBox(width: tinySpacing),
        // Rectangular label skeleton
        Container(
          width: _trackWidth,
          height: _thumbDiameter,
          decoration: BoxDecoration(
            color: skeletonColor,
            borderRadius: BorderRadius.zero,
          ),
        ),
      ],
    );
  }
}
