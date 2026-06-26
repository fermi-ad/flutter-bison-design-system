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

enum _BisonSwitchType { interactive, disabled, readOnly }

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
/// ## Disabled (pass null to onChanged)
/// ```dart
/// BisonSwitch(
///   value: _isOn,
///   onChanged: null,
/// )
/// ```
///
/// ## Read-only (value driven by an external source, no user interaction)
/// ```dart
/// BisonSwitch.readOnly(
///   value: _sensorReading,
///   onLabel: 'Active',
///   offLabel: 'Inactive',
/// )
/// ```
///
/// ## With label and state labels
/// ```dart
/// BisonSwitch(
///   value: _isOn,
///   onChanged: (v) => setState(() => _isOn = v),
///   label: 'Notifications',
///   onLabel: 'On',
///   offLabel: 'Off',
/// )
/// ```
///
/// ## Loading skeleton
/// ```dart
/// BisonSwitch(
///   value: false,
///   onChanged: null,
///   isLoading: true,
/// )
/// ```
class BisonSwitch extends StatefulWidget {
  /// Whether the switch is currently toggled on.
  final bool value;

  /// Called when the user taps the switch (or activates it via keyboard).
  ///
  /// Pass `null` to render the switch in a disabled state — it will use
  /// disabled color tokens and ignore all interaction.
  ///
  /// Not available on [BisonSwitch.readOnly].
  final ValueChanged<bool>? onChanged;

  /// Optional label rendered above the switch.
  final String? label;

  /// Text rendered to the right of the switch when [value] is `true`.
  ///
  /// The widget resolves which string to display internally based on [value],
  /// so both [onLabel] and [offLabel] should be provided together.
  final String? onLabel;

  /// Text rendered to the right of the switch when [value] is `false`.
  ///
  /// The widget resolves which string to display internally based on [value],
  /// so both [onLabel] and [offLabel] should be provided together.
  final String? offLabel;

  /// Controls the track/thumb dimensions.
  final BisonSwitchSize size;

  /// When `true`, renders skeleton placeholder shapes instead of the live
  /// switch. Use this while the underlying data is loading.
  final bool isLoading;

  /// An optional [FocusNode] to control focus externally.
  ///
  /// Only meaningful for the interactive variant (non-null [onChanged]).
  final FocusNode? focusNode;

  /// Whether the switch should request focus automatically.
  ///
  /// Only meaningful for the interactive variant (non-null [onChanged]).
  /// Defaults to false.
  final bool autofocus;

  // Internal type — derived at construction time, never set by the caller.
  final _BisonSwitchType _type;

  // ---------------------------------------------------------------------------
  // Private base constructor
  // ---------------------------------------------------------------------------

  const BisonSwitch._({
    super.key,
    required this.value,
    required _BisonSwitchType type,
    this.onChanged,
    this.label,
    this.onLabel,
    this.offLabel,
    this.size = BisonSwitchSize.medium,
    this.isLoading = false,
    this.focusNode,
    this.autofocus = false,
  }) : _type = type;

  // ---------------------------------------------------------------------------
  // Public constructors
  // ---------------------------------------------------------------------------

  /// Creates an interactive or disabled switch.
  ///
  /// - When [onChanged] is non-null the switch is **interactive**: it responds
  ///   to taps and keyboard activation and calls [onChanged] with the new value.
  /// - When [onChanged] is `null` the switch is **disabled**: it uses disabled
  ///   color tokens and ignores all interaction.
  ///
  const BisonSwitch({
    Key? key,
    required bool value,
    required ValueChanged<bool>? onChanged,
    String? label,
    String? onLabel,
    String? offLabel,
    BisonSwitchSize size = BisonSwitchSize.medium,
    bool isLoading = false,
    FocusNode? focusNode,
    bool autofocus = false,
  }) : this._(
         key: key,
         value: value,
         type: onChanged != null
             ? _BisonSwitchType.interactive
             : _BisonSwitchType.disabled,
         onChanged: onChanged,
         label: label,
         onLabel: onLabel,
         offLabel: offLabel,
         size: size,
         isLoading: isLoading,
         focusNode: focusNode,
         autofocus: autofocus,
       );

  /// Creates a read-only switch.
  ///
  /// The switch uses a distinct visual treatment (transparent background with
  /// a plain border) and does not respond to user interaction.
  const BisonSwitch.readOnly({
    Key? key,
    required bool value,
    String? label,
    String? onLabel,
    String? offLabel,
    BisonSwitchSize size = BisonSwitchSize.medium,
    bool isLoading = false,
  }) : this._(
         key: key,
         value: value,
         type: _BisonSwitchType.readOnly,
         label: label,
         onLabel: onLabel,
         offLabel: offLabel,
         size: size,
         isLoading: isLoading,
       );

  @override
  State<BisonSwitch> createState() => _BisonSwitchState();
}

class _BisonSwitchState extends State<BisonSwitch> {
  bool _isFocused = false;

  // -------------------------------------------------------------------------
  // Helpers
  // -------------------------------------------------------------------------

  bool get _isInteractive => widget._type == _BisonSwitchType.interactive;

  double get _trackWidth => widget.size == BisonSwitchSize.medium
      ? _defaultTrackWidth
      : _smallTrackWidth;

  double get _trackHeight => widget.size == BisonSwitchSize.medium
      ? _defaultTrackHeight
      : _smallTrackHeight;

  double get _thumbDiameter => widget.size == BisonSwitchSize.medium
      ? _defaultThumbDiameter
      : _smallThumbDiameter;

  /// The status string to display to the right of the switch, resolved from
  /// [value] and the [onLabel]/[offLabel] pair.
  String? get _resolvedStatusLabel =>
      widget.value ? widget.onLabel : widget.offLabel;

  // -------------------------------------------------------------------------
  // Color resolution
  // -------------------------------------------------------------------------

  Color _trackColor(final BisonThemeTokens theme) {
    switch (widget._type) {
      case _BisonSwitchType.disabled:
        return theme.selectorSelectorSwitchFillDisabled;
      case _BisonSwitchType.readOnly:
        return theme.surfaceTransparent;
      case _BisonSwitchType.interactive:
        return widget.value
            ? theme.selectorSelectorPrimary
            : theme.selectorSelectorSwitchFill;
    }
  }

  Color _thumbColor(final BisonThemeTokens theme) {
    switch (widget._type) {
      case _BisonSwitchType.disabled:
        return theme.selectorSelectorSwitchDisabled;
      case _BisonSwitchType.readOnly:
        return theme.iconPlain;
      case _BisonSwitchType.interactive:
        return theme.selectorSelectorCheckboxCheck;
    }
  }

  Color _textColor(final BisonThemeTokens theme) {
    return widget._type == _BisonSwitchType.disabled
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

    if (widget.isLoading) {
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
        border: widget._type == _BisonSwitchType.readOnly
            ? Border.all(color: bison.theme.borderPlain, width: 1.0)
            : null,
        boxShadow: _isFocused && _isInteractive
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

    // Wrap in interaction handlers only for the interactive variant.
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
        child: GestureDetector(onTap: _handleTap, child: track),
      );
    }

    // Row: [track] [optional status label]
    final statusLabel = _resolvedStatusLabel;
    final Widget switchRow = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        track,
        if (statusLabel != null) ...[
          SizedBox(width: bison.spacing.tinySpacing),
          SizedBox(
            width: _trackWidth,
            child: Text(
              statusLabel,
              style: bison.typography.bodyLarge.copyWith(color: textColor),
              maxLines: 1,
              softWrap: false,
              overflow: TextOverflow.ellipsis,
            ),
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
    final cornerRadius = _trackHeight / 2;

    final trackSkeleton = Container(
      width: _trackWidth,
      height: _trackHeight,
      decoration: BoxDecoration(
        color: skeletonColor,
        borderRadius: BorderRadius.circular(cornerRadius),
      ),
    );

    // Rectangular label skeleton — same width as the track, height matches
    // the thumb diameter so it aligns visually with the track centre.
    final labelSkeleton = Container(
      width: _trackWidth,
      height: _thumbDiameter,
      decoration: BoxDecoration(
        color: skeletonColor,
        borderRadius: BorderRadius.circular(2.0),
      ),
    );

    final switchRow = Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        trackSkeleton,
        SizedBox(width: tinySpacing),
        labelSkeleton,
      ],
    );

    // Mirror the live layout: if a label was provided, render a label
    // placeholder above the switch row.
    if (widget.label != null) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: _trackWidth * 1.5,
            height: _thumbDiameter,
            decoration: BoxDecoration(
              color: skeletonColor,
              borderRadius: BorderRadius.circular(2.0),
            ),
          ),
          SizedBox(height: tinySpacing),
          switchRow,
        ],
      );
    }

    return switchRow;
  }
}
