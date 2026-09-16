import 'package:bison_design_system/core_widgets.dart' show BisonDataTable;
import 'package:flutter/material.dart';
import 'package:widgetbook_annotation/widgetbook_annotation.dart' as widgetbook;

@widgetbook.UseCase(name: 'Default', type: BisonDataTable)
Widget buildBisonDataTable(BuildContext context) {
  return const _InteractiveDataTableUseCase();
}

class _InteractiveDataTableUseCase extends StatefulWidget {
  const _InteractiveDataTableUseCase();

  @override
  State<_InteractiveDataTableUseCase> createState() =>
      _InteractiveDataTableUseCaseState();
}

class _InteractiveDataTableUseCaseState
    extends State<_InteractiveDataTableUseCase> {
  static const _pageSizeOptions = [5, 10, 25];
  final List<List<String>> _projects = List<List<String>>.generate(
    12,
    (index) => [
      'Project ${index + 1}',
      index.isEven ? 'Active' : 'Planned',
      'Team ${(index % 3) + 1}',
      'Sep ${index + 1}, 2026',
    ],
  );
  var _pageSize = _pageSizeOptions.first;
  var _currentPage = 1;

  int get _totalPages => (_projects.length / _pageSize).ceil();

  List<List<String>> get _visibleProjects {
    final startIndex = (_currentPage - 1) * _pageSize;
    final endIndex = (startIndex + _pageSize).clamp(0, _projects.length);
    return _projects.sublist(startIndex, endIndex);
  }

  void _addProject() {
    setState(() {
      _projects.add([
        'Project ${_projects.length + 1}',
        'Planned',
        'Team ${(_projects.length % 3) + 1}',
        'Sep ${_projects.length + 1}, 2026',
      ]);
      _currentPage = _totalPages;
    });
  }

  void _goToPreviousPage() {
    if (_currentPage > 1) {
      setState(() => _currentPage--);
    }
  }

  void _goToNextPage() {
    if (_currentPage < _totalPages) {
      setState(() => _currentPage++);
    }
  }

  void _selectPageSize(final int pageSize) {
    setState(() {
      _pageSize = pageSize;
      _currentPage = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BisonDataTable(
      title: 'Projects',
      description: '${_projects.length} projects',
      headers: const ['Project', 'Status', 'Team', 'Updated'],
      rows: _visibleProjects,
      pageSize: _pageSize,
      totalItems: _projects.length,
      currentPage: _currentPage,
      totalPages: _totalPages,
      pageSizeOptions: _pageSizeOptions,
      onPageSizeChanged: _selectPageSize,
      onAdd: _addProject,
      onPreviousPage: _currentPage > 1 ? _goToPreviousPage : null,
      onNextPage: _currentPage < _totalPages ? _goToNextPage : null,
    );
  }
}
