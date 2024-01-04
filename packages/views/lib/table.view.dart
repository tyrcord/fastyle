import 'package:fastyle_core/fastyle_core.dart';
import 'package:flutter/material.dart';

// Class representing a table column with necessary attributes.
class FastTableColumnDescriptor {
  final String id;
  final String title;
  final TableColumnWidth width;
  final TextAlign textAlign;

  const FastTableColumnDescriptor({
    required this.id,
    required this.title,
    this.width = const FlexColumnWidth(),
    this.textAlign = TextAlign.left,
  });
}

// Widget for displaying a table view with customizable rows and columns.
class FastTableView<T> extends StatelessWidget {
  final String? Function(FastTableColumnDescriptor column, T row)
      cellTextContentBuilder;
  final List<FastTableColumnDescriptor> columns;
  final List<T> rows;
  final Color? borderColor;

  const FastTableView({
    super.key,
    required this.cellTextContentBuilder,
    required this.columns,
    required this.rows,
    this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: _getColumnWidths(),
      children: [
        _createTableHeader(context),
        ..._createTableRows(context),
      ],
    );
  }

  // Generates a map of column widths for the table.
  Map<int, TableColumnWidth> _getColumnWidths() {
    final columnWidths = <int, TableColumnWidth>{};

    for (var i = 0; i < columns.length; i++) {
      columnWidths[i] = columns[i].width;
    }

    return columnWidths;
  }

  // Creates the header row of the table.
  TableRow _createTableHeader(BuildContext context) {
    return TableRow(
      children: columns.map((column) => _createHeaderCell(column)).toList(),
    );
  }

  // Helper to create a cell in the header.
  Widget _createHeaderCell(FastTableColumnDescriptor column) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 12.0, right: 12.0),
        child: FastSecondarySubtitle(
          textAlign: column.textAlign,
          text: column.title,
        ),
      ),
    );
  }

  // Generates the rows of the table.
  List<TableRow> _createTableRows(BuildContext context) {
    return rows.map((row) => _createTableRow(row, context)).toList();
  }

  // Creates a single table row.
  TableRow _createTableRow(T row, BuildContext context) {
    const cellPadding = EdgeInsets.only(top: 6.0, bottom: 6.0, right: 12.0);
    final BoxDecoration boxDecoration = ThemeHelper.createBorderSide(
      context,
      color: borderColor,
      borderWidth: 0.5,
    );

    return TableRow(
      decoration: boxDecoration,
      children: columns
          .map((column) => _createRowCell(column, row, cellPadding))
          .toList(),
    );
  }

  // Helper to create a cell in a table row.
  Widget _createRowCell(
      FastTableColumnDescriptor column, T row, EdgeInsets padding) {
    return TableCell(
      child: Padding(
        padding: padding,
        child: FastSecondaryBody(
          textAlign: column.textAlign,
          text: cellTextContentBuilder(column, row) ?? '',
        ),
      ),
    );
  }
}
