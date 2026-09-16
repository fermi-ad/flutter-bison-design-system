import 'package:flutter/material.dart';
import 'package:bison_design_system/core_widgets.dart'
    show
        BisonButton,
        BisonDivider,
        BisonDividerOrientation,
        BisonIconButton,
        BisonMenu,
        BisonMenuItem;
import 'package:bison_design_system/theme.dart' show BisonContext;

/// A standard Bison data table with an optional title, toolbar, and pagination.
class BisonDataTable extends StatelessWidget {
  /// Creates a Bison data table.
  const BisonDataTable({
    super.key,
    required this.headers,
    required this.rows,
    this.title,
    this.description,
    this.actionLabel = 'Button',
    this.onSearch,
    this.onFilter,
    this.onSettings,
    this.onAdd,
    this.onAction,
    this.pageSize = 100,
    this.totalItems = 100,
    this.currentPage = 1,
    this.totalPages = 10,
    this.pageSizeOptions = const [10, 25, 50, 100],
    this.onPageSizeChanged,
    this.onPreviousPage,
    this.onNextPage,
    this.width = 800,
  }) : assert(pageSize > 0),
       assert(totalItems >= 0),
       assert(currentPage > 0),
       assert(totalPages > 0),
       assert(width > 0);

  /// The labels displayed in the table header.
  final List<String> headers;

  /// The text values displayed in each table row.
  final List<List<String>> rows;

  /// An optional table title.
  final String? title;

  /// An optional description displayed beneath [title].
  final String? description;

  /// The label for the toolbar text action.
  final String actionLabel;

  /// Toolbar action callbacks.
  final VoidCallback? onSearch;
  final VoidCallback? onFilter;
  final VoidCallback? onSettings;
  final VoidCallback? onAdd;
  final VoidCallback? onAction;

  /// Pagination values and callbacks.
  final int pageSize;
  final int totalItems;
  final int currentPage;
  final int totalPages;
  final List<int> pageSizeOptions;
  final ValueChanged<int>? onPageSizeChanged;
  final VoidCallback? onPreviousPage;
  final VoidCallback? onNextPage;

  /// The fixed design width of the table.
  final double width;

  @override
  Widget build(final BuildContext context) {
    final bison = context.bison;
    final startItem = totalItems == 0 ? 0 : (currentPage - 1) * pageSize + 1;
    final endItem = (currentPage * pageSize).clamp(0, totalItems);

    return Semantics(
      label: title ?? 'Data table',
      child: SizedBox(
        width: width,
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: bison.theme.tableContent,
            border: Border.all(color: bison.theme.borderPlain),
            borderRadius: BorderRadius.circular(bison.corners.cornerSmall),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(bison.corners.cornerSmall),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (title != null || description != null)
                  _TableHeader(title: title, description: description),
                _TableToolbar(
                  actionLabel: actionLabel,
                  onSearch: onSearch,
                  onFilter: onFilter,
                  onSettings: onSettings,
                  onAdd: onAdd,
                  onAction: onAction,
                ),
                _TableHeading(headers: headers),
                for (final row in rows) _TableRow(values: row),
                _TablePagination(
                  pageSize: pageSize,
                  startItem: startItem,
                  endItem: endItem,
                  totalItems: totalItems,
                  currentPage: currentPage,
                  totalPages: totalPages,
                  pageSizeOptions: pageSizeOptions,
                  onPageSizeChanged: onPageSizeChanged,
                  onPreviousPage: onPreviousPage,
                  onNextPage: onNextPage,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TableHeader extends StatelessWidget {
  const _TableHeader({this.title, this.description});

  final String? title;
  final String? description;

  @override
  Widget build(final BuildContext context) {
    final bison = context.bison;

    return Container(
      width: double.infinity,
      color: bison.theme.tableHeader,
      padding: EdgeInsets.fromLTRB(
        bison.spacing.smallSpacing,
        bison.spacing.smallSpacing,
        bison.spacing.smallSpacing,
        bison.spacing.standardSpacing,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null)
            Text(
              title!,
              style: bison.typography.h1.copyWith(color: bison.theme.textPlain),
            ),
          if (description != null)
            Text(
              description!,
              style: bison.typography.bodySmall.copyWith(
                color: bison.theme.textPlain,
              ),
            ),
        ],
      ),
    );
  }
}

class _TableToolbar extends StatelessWidget {
  const _TableToolbar({
    required this.actionLabel,
    this.onSearch,
    this.onFilter,
    this.onSettings,
    this.onAdd,
    this.onAction,
  });

  final String actionLabel;
  final VoidCallback? onSearch;
  final VoidCallback? onFilter;
  final VoidCallback? onSettings;
  final VoidCallback? onAdd;
  final VoidCallback? onAction;

  @override
  Widget build(final BuildContext context) {
    return SizedBox(
      height: 40,
      width: double.infinity,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          BisonIconButton.ghost(
            icon: const Icon(Icons.search),
            onPressed: onSearch,
          ),
          BisonIconButton.ghost(
            icon: const Icon(Icons.filter_list),
            onPressed: onFilter,
          ),
          BisonIconButton.ghost(
            icon: const Icon(Icons.settings),
            onPressed: onSettings,
          ),
          BisonIconButton.ghost(icon: const Icon(Icons.add), onPressed: onAdd),
          BisonButton.ghost(buttonLabel: actionLabel, onPressed: onAction),
        ],
      ),
    );
  }
}

class _TableHeading extends StatelessWidget {
  const _TableHeading({required this.headers});

  final List<String> headers;

  @override
  Widget build(final BuildContext context) {
    final bison = context.bison;

    return Container(
      height: 64,
      color: bison.theme.tableHeader,
      child: Row(
        children: [
          for (final header in headers)
            Expanded(
              child: Padding(
                padding: EdgeInsets.all(bison.spacing.smallSpacing),
                child: Text(
                  header,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: bison.typography.bodyLarge.copyWith(
                    color: bison.theme.textPlain,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _TableRow extends StatelessWidget {
  const _TableRow({required this.values});

  final List<String> values;

  @override
  Widget build(final BuildContext context) {
    final bison = context.bison;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const BisonDivider(),
        SizedBox(
          height: 63,
          child: Row(
            children: [
              for (final value in values)
                Expanded(
                  child: Padding(
                    padding: EdgeInsets.all(bison.spacing.smallSpacing),
                    child: Text(
                      value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: bison.typography.bodyLarge.copyWith(
                        color: bison.theme.textPlain,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TablePagination extends StatelessWidget {
  const _TablePagination({
    required this.pageSize,
    required this.startItem,
    required this.endItem,
    required this.totalItems,
    required this.currentPage,
    required this.totalPages,
    required this.pageSizeOptions,
    this.onPageSizeChanged,
    this.onPreviousPage,
    this.onNextPage,
  });

  final int pageSize;
  final int startItem;
  final int endItem;
  final int totalItems;
  final int currentPage;
  final int totalPages;
  final List<int> pageSizeOptions;
  final ValueChanged<int>? onPageSizeChanged;
  final VoidCallback? onPreviousPage;
  final VoidCallback? onNextPage;

  @override
  Widget build(final BuildContext context) {
    final bison = context.bison;

    return SizedBox(
      height: 48,
      child: Row(
        children: [
          _PageSizeSelector(
            width: 89,
            pageSize: pageSize,
            options: pageSizeOptions,
            onChanged: onPageSizeChanged,
          ),
          const BisonDivider(orientation: BisonDividerOrientation.vertical),
          Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: bison.spacing.smallSpacing,
              ),
              child: Text('$startItem - $endItem of $totalItems items'),
            ),
          ),
          const BisonDivider(orientation: BisonDividerOrientation.vertical),
          _PaginationButton(
            width: 152,
            onPressed: null,
            child: Text('$currentPage  of $totalPages pages'),
          ),
          const BisonDivider(orientation: BisonDividerOrientation.vertical),
          _PaginationButton(
            width: 39,
            onPressed: onPreviousPage,
            child: const Icon(Icons.chevron_left, size: 24),
          ),
          const BisonDivider(orientation: BisonDividerOrientation.vertical),
          _PaginationButton(
            width: 39,
            onPressed: onNextPage,
            child: const Icon(Icons.chevron_right, size: 24),
          ),
        ],
      ),
    );
  }
}

class _PageSizeSelector extends StatelessWidget {
  const _PageSizeSelector({
    required this.width,
    required this.pageSize,
    required this.options,
    this.onChanged,
  });

  final double width;
  final int pageSize;
  final List<int> options;
  final ValueChanged<int>? onChanged;

  @override
  Widget build(final BuildContext context) {
    final bison = context.bison;

    return SizedBox(
      width: width,
      height: double.infinity,
      child: BisonMenu(
        builder: (context, focusNode, {required toggleMenu, required isOpen}) {
          return Semantics(
            button: true,
            label: 'Rows per page: $pageSize',
            child: TextButton(
              focusNode: focusNode,
              onPressed: onChanged == null ? null : toggleMenu,
              style: ButtonStyle(
                foregroundColor: WidgetStatePropertyAll(bison.theme.textPlain),
                padding: const WidgetStatePropertyAll(EdgeInsets.zero),
                shape: const WidgetStatePropertyAll(LinearBorder.none),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('$pageSize'),
                  SizedBox(width: bison.spacing.tinySpacing),
                  Icon(
                    isOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    size: 24,
                  ),
                ],
              ),
            ),
          );
        },
        items: [
          for (final option in options)
            BisonMenuItem(
              label: '$option',
              onSelect: onChanged == null ? null : () => onChanged!(option),
            ),
        ],
      ),
    );
  }
}

class _PaginationButton extends StatelessWidget {
  const _PaginationButton({
    required this.width,
    required this.child,
    this.onPressed,
  });

  final double width;
  final Widget child;
  final VoidCallback? onPressed;

  @override
  Widget build(final BuildContext context) {
    final bison = context.bison;

    return SizedBox(
      width: width,
      height: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          foregroundColor: WidgetStatePropertyAll(bison.theme.textPlain),
          padding: const WidgetStatePropertyAll(EdgeInsets.zero),
          shape: const WidgetStatePropertyAll(LinearBorder.none),
        ),
        child: DefaultTextStyle.merge(
          style: bison.typography.bodyLarge,
          child: child,
        ),
      ),
    );
  }
}
