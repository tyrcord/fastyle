// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:t_helpers/helpers.dart';

// Project imports:
import 'package:fastyle_calculator/fastyle_calculator.dart';

/// A class that generates a PDF report for a calculator.
class FastPdfCalculatorReporter {
  /// Generates a PDF report for a calculator.
  ///
  /// The [title] parameter is the title of the report.
  ///
  /// The [inputs] parameter is a list of [FastReportEntry] objects that
  /// represent the inputs of the calculator.
  ///
  /// The [results] parameter is a list of [FastReportEntry] objects that
  /// represent the results of the calculator.
  ///
  /// The [inputTitle] parameter is the title of the inputs section.
  ///
  /// The [resultTitle] parameter is the title of the results section.
  ///
  /// The [dateTitle] parameter is the title of the date section.
  ///
  /// The [disclaimerTitle] parameter is the title of the disclaimer section.
  ///
  /// The [disclaimerText] parameter is the text of the disclaimer section.
  ///
  /// The [italicTextColor] parameter is the color of the italic text.
  ///
  /// The [textColor] parameter is the color of the regular text.
  Future<Uint8List> report({
    required String title,
    required List<FastReportEntry> inputs,
    required List<FastReportEntry> results,
    String inputTitle = 'INPUTS',
    String resultTitle = 'RESULTS',
    String dateTitle = 'Date:',
    String disclaimerTitle = 'DISCLAIMER',
    String? disclaimerText,
    Color? italicTextColor,
    Color? textColor,
    String? author,
    List<FastReportCategoryEntry>? categories,
  }) async {
    final italicStyle = await _getItalicStyle(color: italicTextColor);
    final style = await _getRegularStyle(color: textColor);
    final now = await formatDateTime(DateTime.now());
    final pdf = pw.Document()
      ..addPage(
        pw.MultiPage(
          // TODO: support other page format like us letter
          pageFormat: PdfPageFormat.a4,
          footer: (context) => _buildFooter(context, style),
          build: (context) {
            return [
              pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  // header
                  pw.Wrap(
                    children: [
                      _buildHeaderTitle(title, style),
                      pw.SizedBox(height: 48),
                      _buildDate(dateTitle, now, italicStyle),
                      pw.SizedBox(height: 24),
                      // INPUTS
                      _buildTableSection(inputTitle, inputs, style),
                    ],
                  ),
                  pw.SizedBox(height: 24),
                  pw.Wrap(
                    children: [
                      // RESULTS
                      _buildTableSection(resultTitle, results, style),
                      pw.SizedBox(height: 12),
                    ],
                  ),
                  if (categories != null)
                    pw.Wrap(
                      children: [
                        _buildCategoriesTable(context, categories, style),
                      ],
                    ),
                  pw.Wrap(
                    children: [
                      // DISCLAIMER
                      if (disclaimerText != null)
                        _buildDisclaimer(
                            disclaimerTitle, disclaimerText, style),
                      if (author != null)
                        pw.Align(
                          alignment: pw.Alignment.center,
                          child: pw.Text(
                            author,
                            style: italicStyle.copyWith(fontSize: 7),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ];
          },
        ),
      );

    return pdf.save();
  }

  pw.Widget _buildCategoriesTable(
    pw.Context context,
    List<FastReportCategoryEntry> categories,
    pw.TextStyle style,
  ) {
    return pw.Table(
      columnWidths: const {
        0: pw.FlexColumnWidth(1),
        1: pw.FlexColumnWidth(1),
      },
      children: transformTo2DArray(categories, 2).map((subCategories) {
        var index = 0;

        return pw.TableRow(
          children: subCategories.map((category) {
            return pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.stretch,
              children: [
                pw.Container(
                  margin:
                      index++ == 0 ? const pw.EdgeInsets.only(right: 12) : null,
                  padding: const pw.EdgeInsets.only(top: 6, bottom: 6),
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(
                      bottom: pw.BorderSide(color: PdfColors.grey300, width: 1),
                    ),
                  ),
                  child: pw.Text(
                    category.name,
                    style: style.copyWith(fontSize: 8),
                  ),
                ),
                pw.Table(
                  columnWidths: const {
                    0: pw.FlexColumnWidth(1),
                    1: pw.FlexColumnWidth(1),
                  },
                  children: transformTo2DArray(category.entries, 2)
                      .map((entries) => _buildTableRow(entries, style))
                      .toList(),
                ),
              ],
            );
          }).toList(),
        );
      }).toList(),
    );
  }

  /// Builds the header title of the report.
  pw.Widget _buildHeaderTitle(String title, pw.TextStyle style) {
    return pw.Center(
      child: pw.Text(
        title,
        style: style.copyWith(fontSize: 20),
      ),
    );
  }

  /// Builds the date section of the report.
  pw.Widget _buildDate(String title, String date, pw.TextStyle style) {
    style = style.copyWith(fontSize: 7);

    return pw.Row(
      children: [
        pw.Text(title, style: style),
        pw.SizedBox(width: 2),
        pw.Text(date, style: style),
      ],
    );
  }

  /// Builds the section title of the report.
  pw.Widget _buildSectionTitle(
    String title,
    pw.TextStyle style, {
    bool showBorder = true,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pw.Container(
          padding: const pw.EdgeInsets.only(top: 4, bottom: 4),
          child: pw.Text(
            title,
            style: style.copyWith(fontSize: 8),
            textAlign: showBorder ? pw.TextAlign.center : pw.TextAlign.left,
          ),
          decoration: showBorder
              ? const pw.BoxDecoration(
                  border: pw.Border(
                    bottom: pw.BorderSide(
                      color: PdfColors.grey300,
                      width: 1,
                    ),
                    top: pw.BorderSide(
                      color: PdfColors.grey300,
                      width: 1,
                    ),
                  ),
                )
              : null,
        ),
        pw.SizedBox(height: 12),
      ],
    );
  }

  /// Builds a table section of the report.
  pw.Widget _buildTableSection(
    String title,
    List<FastReportEntry> entries,
    pw.TextStyle style, {
    int columns = 3,
  }) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title, style),
        pw.Table(
          children: transformTo2DArray(entries, columns).map((entries) {
            return _buildTableRow(entries, style);
          }).toList(),
        ),
      ],
    );
  }

  /// Builds a table row of the report.
  pw.TableRow _buildTableRow(
    List<FastReportEntry> entries,
    pw.TextStyle style,
  ) {
    return pw.TableRow(
      children: entries.map((e) {
        return pw.Padding(
          padding: const pw.EdgeInsets.only(top: 6, bottom: 6),
          child: pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              _buildEntryName(e, style),
              pw.SizedBox(height: 4),
              _buildEntryValue(e, style),
            ],
          ),
        );
      }).toList(),
    );
  }

  pw.Widget _buildEntryName(FastReportEntry entry, pw.TextStyle style) {
    return pw.Text(
      entry.name,
      style: style.copyWith(
        color: PdfColor.fromInt(kFastLightSecondaryLabelColor.value),
        fontSize: 10,
      ),
    );
  }

  pw.Widget _buildEntryValue(FastReportEntry entry, pw.TextStyle style) {
    if (entry.color != null) {
      style = style.copyWith(color: PdfColor.fromInt(entry.color!.value));
    }

    return pw.Text(entry.value, textAlign: pw.TextAlign.right, style: style);
  }

  /// Builds the disclaimer section of the report.
  pw.Widget _buildDisclaimer(String title, String content, pw.TextStyle style) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 24),
        _buildSectionTitle(title, style, showBorder: false),
        pw.Text(
          content,
          style: style.copyWith(
            fontSize: 10,
            color: PdfColor.fromInt(kFastLightTertiaryLabelColor.value),
          ),
        ),
        pw.SizedBox(height: 24),
      ],
    );
  }

  pw.Widget _buildFooter(pw.Context context, pw.TextStyle style) {
    return pw.Align(
      alignment: pw.Alignment.centerRight,
      child: pw.Text(
        '${context.pageNumber}/${context.pagesCount}',
        style: style.copyWith(
          color: PdfColor.fromInt(kFastLightSecondaryLabelColor.value),
          fontSize: 10,
        ),
      ),
    );
  }

  /// Gets the regular text style of the report.
  Future<pw.TextStyle> _getRegularStyle({Color? color}) async {
    final font = await PdfGoogleFonts.barlowSemiCondensedMedium();
    late PdfColor pdfColor;

    if (color == null) {
      pdfColor = PdfColor.fromInt(kFastLightLabelColor.value);
    } else {
      pdfColor = PdfColor.fromInt(color.value);
    }

    return pw.TextStyle(font: font, fontSize: 11, color: pdfColor);
  }

  /// Gets the italic text style of the report.
  Future<pw.TextStyle> _getItalicStyle({Color? color}) async {
    final font = await PdfGoogleFonts.barlowSemiCondensedMediumItalic();
    late PdfColor pdfColor;

    if (color == null) {
      pdfColor = PdfColor.fromInt(kFastLightSecondaryLabelColor.value);
    } else {
      pdfColor = PdfColor.fromInt(color.value);
    }

    return pw.TextStyle(font: font, fontSize: 10, color: pdfColor);
  }
}
