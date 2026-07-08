import 'package:flutter/widgets.dart';
import 'package:bison_design_system/core_widgets.dart' show BisonRadioButton;
import 'package:bison_design_system/theme.dart' show BisonContext;

/// Immutable config for a single [BisonRadioGroup] option.
class BisonRadioGroupItem {
  /// Visible label for this option.
  final String label;

  /// Whether this specific option can be interacted with.
  final bool enabled;

  const BisonRadioGroupItem({required this.label, this.enabled = true});
}

/// A labeled wrapper around [BisonRadioButton] primitives.
///
/// The parent owns selection state and updates [selectedIndex] in response to
/// [onChanged].
class BisonRadioGroup extends StatelessWidget {
  /// Ordered options in this group.
  final List<BisonRadioGroupItem> items;

  /// Currently selected option index.
  final int selectedIndex;

  /// Called when a new option is selected.
  ///
  /// Pass `null` to disable the entire group.
  final ValueChanged<int>? onChanged;

  /// Layout direction for the group. Defaults to vertical.
  final Axis direction;

  const BisonRadioGroup({
    super.key,
    required this.items,
    required this.selectedIndex,
    required this.onChanged,
    this.direction = Axis.vertical,
  });

  bool _isItemInteractive(final BisonRadioGroupItem item) {
    return onChanged != null && item.enabled;
  }

  void _select(final int index) {
    if (index == selectedIndex) return;
    onChanged?.call(index);
  }

  @override
  Widget build(final BuildContext context) {
    final bison = context.bison;
    final gap = direction == Axis.vertical
        ? SizedBox(height: bison.spacing.tinySpacing)
        : SizedBox(width: bison.spacing.smallSpacing);

    final children = <Widget>[];
    for (var index = 0; index < items.length; index += 1) {
      final item = items[index];
      final itemInteractive = _isItemInteractive(item);

      children.add(
        GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: itemInteractive ? () => _select(index) : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              BisonRadioButton(
                selected: selectedIndex == index,
                onChanged: itemInteractive ? (_) => _select(index) : null,
              ),
              SizedBox(width: bison.spacing.tinySpacing),
              Text(
                item.label,
                style: bison.typography.bodyLarge.copyWith(
                  color: itemInteractive
                      ? bison.theme.textPlain
                      : bison.theme.textDisabled,
                ),
              ),
            ],
          ),
        ),
      );

      if (index < items.length - 1) {
        children.add(gap);
      }
    }

    return direction == Axis.vertical
        ? Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: children,
          )
        : Row(mainAxisSize: MainAxisSize.min, children: children);
  }
}
