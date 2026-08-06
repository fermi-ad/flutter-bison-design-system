import 'package:flutter/widgets.dart';
import 'package:bison_design_system/theme.dart' show BisonContext, BisonTokens;

enum _CardType { stackedWithImage, horizontalWithImage }

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
///   secondaryAction: TextButton(onPressed: () {}, child: Text('Cancel')),
/// );
/// ```
///
/// ## Horizontal with image
/// ```dart
/// BisonCard.horizontalWithImage(
///   avatar: CircleAvatar(child: Text('B')),
///   headerText: 'Header',
///   subheadText: 'Subhead',
///   media: Image.network('https://example.com/thumb.png'),
/// )
/// ```
class BisonCard extends StatelessWidget {
  /// Which card layout variant to render.
  final _CardType _cardType;

  /// Circular avatar widget displayed in the header row.
  final Widget avatar;

  /// Primary text in the header row.
  final String headerText;

  /// Secondary text in the header row, displayed below [headerText].
  final String? subheadText;

  /// Trailing icon button in the header row (e.g. three-dot menu).
  final Widget? trailingIconButton;

  /// Widget slot for image/illustration content.
  ///
  /// Required for [BisonCard.stackedWithImage]; optional for
  /// [BisonCard.horizontalWithImage] (displays as an 80×80 thumbnail).
  final Widget? media;

  /// Title text displayed below the media area (stacked variant only).
  final String? title;

  /// Subtitle text displayed below the title (stacked variant only).
  final String? subtitle;

  /// Supporting text, constrained to a maximum of 4 lines with ellipsis
  /// overflow (stacked variant only).
  final String? supportingText;

  /// Primary action widget displayed in the button row (stacked variant only).
  final Widget? primaryAction;

  /// Optional secondary action widget displayed in the button row
  /// (stacked variant only).
  final Widget? secondaryAction;

  /// Creates a stacked card layout with an image/media area.
  const BisonCard.stackedWithImage({
    super.key,
    required this.avatar,
    required this.headerText,
    this.subheadText,
    this.trailingIconButton,
    required Widget this.media,
    required String this.title,
    this.subtitle,
    this.supportingText,
    this.primaryAction,
    this.secondaryAction,
  }) : _cardType = _CardType.stackedWithImage;

  /// Creates a horizontal card layout with a small 80×80 media thumbnail.
  ///
  /// This variant only renders a header row and an optional media thumbnail
  /// side-by-side. It does not support title, subtitle, supporting text, or
  /// action buttons.
  const BisonCard.horizontalWithImage({
    super.key,
    required this.avatar,
    required this.headerText,
    this.subheadText,
    this.media,
  }) : _cardType = _CardType.horizontalWithImage,
       trailingIconButton = null,
       title = null,
       subtitle = null,
       supportingText = null,
       primaryAction = null,
       secondaryAction = null;

  @override
  @override
  Widget build(BuildContext context) {
    final bison = context.bison;

    final card = Container(
      decoration: BoxDecoration(
        color: bison.theme.surfaceDefault,
        border: Border.all(color: bison.theme.borderPlain),
        borderRadius: BorderRadius.circular(bison.corners.cornerLarge),
      ),
      child: switch (_cardType) {
        _CardType.stackedWithImage => _buildStacked(bison),
        _CardType.horizontalWithImage => _buildHorizontal(bison),
      },
    );

    return switch (_cardType) {
      _CardType.stackedWithImage => card,
      _CardType.horizontalWithImage => SizedBox(
        width: 400,
        height: 120,
        child: card,
      ),
    };
  }

  Widget _buildHeaderRow(BisonTokens bison) {
    return Row(
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
    );
  }

  Widget _buildStacked(BisonTokens bison) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header row
        Padding(
          padding: EdgeInsets.all(bison.spacing.smallSpacing),
          child: _buildHeaderRow(bison),
        ),

        // Media area
        ClipRRect(
          child: SizedBox(width: double.infinity, height: 222, child: media),
        ),

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
              Text(title!, style: bison.typography.h3),
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
    );
  }

  Widget _buildHorizontal(BisonTokens bison) {
    return Padding(
      padding: EdgeInsets.all(bison.spacing.smallSpacing),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Header content (takes remaining space)
          Expanded(child: _buildHeaderRow(bison)),

          // Optional 80×80 media thumbnail
          if (media != null) ...[
            SizedBox(width: bison.spacing.smallSpacing),
            ClipRRect(
              borderRadius: BorderRadius.circular(bison.corners.cornerLarge),
              child: SizedBox(width: 80, height: 80, child: media),
            ),
          ],
        ],
      ),
    );
  }
}
