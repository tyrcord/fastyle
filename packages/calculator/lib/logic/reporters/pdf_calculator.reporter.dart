import 'package:fastyle_calculator/fastyle_calculator.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:t_helpers/helpers.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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
  }) async {
    final italicStyle = await _getItalicStyle(color: italicTextColor);
    final style = await _getRegularStyle(color: textColor);
    final now = await formatDateTime(DateTime.now());
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // header
              _buildHeaderTitle(title, style),
              pw.SizedBox(height: 40),
              _buildDate(dateTitle, now, italicStyle),
              pw.SizedBox(height: 30),
              // INPUTS
              _buildTableSection(inputTitle, inputs, style),
              // RESULTS
              _buildSectionTitle(resultTitle, style),
              _buildTableSection(resultTitle, results, style),
              // DISCLAIMER
              if (disclaimerText != null)
                _buildDisclaimer(disclaimerTitle, disclaimerText, style),
            ],
          );
        },
      ),
    );

    return pdf.save();
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
  pw.Widget _buildSectionTitle(String title, pw.TextStyle style) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          title,
          style: style.copyWith(
            fontSize: 8,
            color: PdfColor.fromInt(kFastLightTertiaryLabelColor.value),
          ),
        ),
        pw.SizedBox(height: 10),
      ],
    );
  }

  /// Builds a table section of the report.
  pw.Widget _buildTableSection(
    String title,
    List<FastReportEntry> entries,
    pw.TextStyle style,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        _buildSectionTitle(title, style),
        pw.Table(
          children: entries.map((e) {
            return _buildTableRow(e.name, e.value, style);
          }).toList(),
        ),
        pw.SizedBox(height: 20),
      ],
    );
  }

  /// Builds a table row of the report.
  pw.TableRow _buildTableRow(
    String title,
    String value,
    pw.TextStyle style,
  ) {
    return pw.TableRow(
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.only(top: 6, bottom: 6),
          child: pw.Row(
            children: [
              pw.Text(
                title,
                style: style.copyWith(
                  color: PdfColor.fromInt(kFastLightSecondaryLabelColor.value),
                  fontSize: 10,
                ),
              ),
              pw.Text(
                value,
                textAlign: pw.TextAlign.right,
                style: style,
              ),
            ],
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          ),
        ),
      ],
      decoration: const pw.BoxDecoration(
        border: pw.Border(
          bottom: pw.BorderSide(
            color: PdfColors.grey200,
            width: 1,
          ),
        ),
      ),
    );
  }

  /// Builds the disclaimer section of the report.
  pw.Widget _buildDisclaimer(String title, String content, pw.TextStyle style) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(height: 20),
        _buildSectionTitle(title, style),
        pw.Text(
          content,
          style: style.copyWith(
            fontSize: 10,
            color: PdfColor.fromInt(kFastLightTertiaryLabelColor.value),
          ),
        ),
        pw.SizedBox(height: 20),
      ],
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
