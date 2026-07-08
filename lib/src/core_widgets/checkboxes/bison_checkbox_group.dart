import 'package:flutter/widgets.dart';
import 'package:bison_design_system/core_widgets.dart'
    show BisonCheckbox, BisonCheckboxValue;
import 'package:bison_design_system/theme.dart' show BisonContext;

/// Immutable config for a single [BisonCheckboxGroup] option.
class BisonCheckboxGroupItem {
  /// Visible label for this option.
  final String label;

  /// Current value of this option.
  final BisonCheckboxValue value;

  /// Whether this specific option can be interacted with.
  final bool enabled;

  const BisonCheckboxGroupItem({
    required this.label,
    required this.value,
    this.enabled = true,
  });
}

/// Callback signature used by [BisonCheckboxGroup].
typedef BisonCheckboxGroupChanged =
    void Function(int index, BisonCheckboxValue currentValue);

/// A labeled wrapper around [BisonCheckbox] primitives.
///
/// The parent owns item state and updates [items] in response to [onChanged].
class BisonCheckboxGroup extends StatelessWidget {
  /// Ordered options in this group.
  final List<BisonCheckboxGroupItem> items;

  /// Called when an option is activated.
  ///
  /// The callback receives both item index and current checkbox value so the
  /// parent can resolve the next state.
  ///
  /// Pass `null` to disable the entire group.
  final BisonCheckboxGroupChanged? onChanged;

  /// Layout direction for the group. Defaults to vertical.
  final Axis direction;

  const BisonCheckboxGroup({
    super.key,
    required this.items,
    required this.onChanged,
    this.direction = Axis.vertical,
  });

  bool _isItemInteractive(final BisonCheckboxGroupItem item) {
    return onChanged != null && item.enabled;
  }

  void _activate(final int index, final BisonCheckboxGroupItem item) {
    onChanged?.call(index, item.value);
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
          onTap: itemInteractive ? () => _activate(index, item) : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              BisonCheckbox(
                value: item.value,
                onChanged: itemInteractive
                    ? (_) => _activate(index, item)
                    : null,
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
