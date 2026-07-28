import 'package:flutter/widgets.dart';
import 'package:bison_design_system/theme.dart' show BisonContext;

/// A card component following the Bison design system.
///
/// ## Stacked with image
/// ```dart
/// BisonCard.stackedWithImage(
///   avatar: CircleAvatar(child: Text('A')),
///   headerText: 'Header',
///   subheadText: 'Subhead',
///   trailingIconButton: IconButton(icon: Icon(Icons.more_vert), onPressed: () {}),
///   media: Image.network('https://example.com/image.png'),
///   title: 'Card Title',
///   subtitle: 'Card Subtitle',
///   supportingText: 'Supporting text goes here.',
///   primaryAction: TextButton(onPressed: () {}, child: Text('Action')),
/// )
/// ```
class BisonCard extends StatelessWidget {
  /// Circular avatar widget displayed in the header row.
  final Widget avatar;

  /// Primary text in the header row.
  final String headerText;

  /// Secondary text in the header row, displayed below [headerText].
  final String? subheadText;

  /// Trailing icon button in the header row (e.g. three-dot menu).
  final Widget? trailingIconButton;

  /// Widget slot for image/illustration content.
  final Widget media;

  /// Title text displayed below the media area.
  final String title;

  /// Subtitle text displayed below the title.
  final String? subtitle;

  /// Supporting text, constrained to a maximum of 4 lines with ellipsis overflow.
  final String? supportingText;

  /// Primary action widget displayed in the button row.
  final Widget? primaryAction;

  /// Optional secondary action widget displayed in the button row.
  final Widget? secondaryAction;

  /// Creates a stacked card layout with an image/media area.
  const BisonCard.stackedWithImage({
    super.key,
    required this.avatar,
    required this.headerText,
    this.subheadText,
    this.trailingIconButton,
    required this.media,
    required this.title,
    this.subtitle,
    this.supportingText,
    this.primaryAction,
    this.secondaryAction,
  });

  @override
  Widget build(BuildContext context) {
    final bison = context.bison;

    return Container(
      decoration: BoxDecoration(
        color: bison.theme.surfaceDefault,
        border: Border.all(color: bison.theme.borderPlain),
        borderRadius: BorderRadius.circular(bison.corners.cornerLarge),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Header row
          Padding(
            padding: EdgeInsets.all(bison.spacing.smallSpacing),
            child: Row(
              children: [
                avatar,
                SizedBox(width: bison.spacing.xSmallSpacing),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(headerText, style: bison.typography.bodyLarge),
                      if (subheadText != null)
                        Text(
                          subheadText!,
                          style: bison.typography.bodySmall.copyWith(
                            color: bison.theme.textMuted,
                          ),
                        ),
                    ],
                  ),
                ),
                ?trailingIconButton,
              ],
            ),
          ),

          // Media area
          ClipRRect(child: SizedBox(width: 360, height: 222, child: media)),

          // Title + Subtitle
          Padding(
            padding: EdgeInsets.fromLTRB(
              bison.spacing.smallSpacing,
              bison.spacing.smallSpacing,
              bison.spacing.smallSpacing,
              0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: bison.typography.h3),
                if (subtitle != null)
                  Padding(
                    padding: EdgeInsets.only(top: bison.spacing.microSpacing),
                    child: Text(
                      subtitle!,
                      style: bison.typography.bodySmall.copyWith(
                        color: bison.theme.textMuted,
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Supporting text
          if (supportingText != null)
            Padding(
              padding: EdgeInsets.fromLTRB(
                bison.spacing.smallSpacing,
                bison.spacing.tinySpacing,
                bison.spacing.smallSpacing,
                0,
              ),
              child: Text(
                supportingText!,
                style: bison.typography.bodySmall,
                maxLines: 4,
                overflow: TextOverflow.ellipsis,
              ),
            ),

          // Button row
          if (primaryAction != null || secondaryAction != null)
            Padding(
              padding: EdgeInsets.all(bison.spacing.smallSpacing),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                spacing: bison.spacing.tinySpacing,
                children: [?secondaryAction, ?primaryAction],
              ),
            ),
        ],
      ),
    );
  }
}
