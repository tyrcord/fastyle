import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:t_helpers/helpers.dart';
import 'package:flutter/material.dart';

/// This widget is used to display a single item in the calculation history list
class FastDigitCalculatorHistoryListItem extends StatelessWidget {
  /// The operation to display in the history item
  final TSimpleOperation? operation;

  /// Constructor for the FastDigitCalculatorHistoryListItem widget
  const FastDigitCalculatorHistoryListItem({
    Key? key,
    required this.operation,
  }) : super(key: key);

  /// This method returns a list of TextSpan objects, which is used to display
  /// the calculation history.
  List<TextSpan> _buildTextsSpan(BuildContext context) {
    final textSpans = <TextSpan>[];

    // If the operation is not null, add each operand and operator to the
    // textSpans list.
    if (operation != null) {
      for (var i = 0; i < operation!.operands.length; i++) {
        final operand = operation!.operands[i];
        final isOperator = i == 0;

        if (isOperator && operation!.operator != null) {
          textSpans.add(_buildOperandTextSpan(operand));
          textSpans.add(_buildOperatorTextSpan(context, operation!.operator!));
        } else {
          // If the last operand is a percent, add a '%' sign to it.
          if (i == operation!.operands.length - 1) {
            textSpans.add(_buildOperandTextSpan(
              operand,
              percent: operation!.isLastOperandPercent,
            ));
          } else {
            textSpans.add(_buildOperandTextSpan(operand));
          }
        }
      }

      if (operation!.result != null) {
        textSpans.add(_buildOperatorTextSpan(context, '='));
        textSpans.add(_buildOperandTextSpan(operation!.result!));
      }
    }

    return textSpans;
  }

  /// This method creates a TextSpan object for operators.
  TextSpan _buildOperatorTextSpan(BuildContext context, String operator) {
    return TextSpan(
      style: TextStyle(
        color: _getPinkColor(context),
        fontWeight: FontWeight.w400,
        fontSize: 20.0,
      ),
      // Add spaces around the operator for better readability.
      text: " $operator ",
    );
  }

  /// This method creates a TextSpan object for operands.
  TextSpan _buildOperandTextSpan(String text, {bool percent = false}) {
    final operand = double.tryParse(text) ?? 0;
    final formattedOperand = formatDecimal(operand);

    return TextSpan(
      text: percent ? '$formattedOperand%' : formattedOperand,
      style: TextStyle(
        color: Colors.grey[500],
        fontWeight: FontWeight.w400,
        fontSize: 20.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (operation != null) {
      final textSpans = _buildTextsSpan(context);

      // Return a ListTile widget that displays the history item using a
      // RichText widget.
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0),
        child: ListTile(
          dense: true,
          title: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: RichText(
              text: TextSpan(children: textSpans),
            ),
          ),
        ),
      );
    }

    // Return an empty SizedBox widget if the operation is null.
    return const SizedBox();
  }

  /// This method returns a pink color based on the app's theme.
  Color _getPinkColor(BuildContext context) {
    final palette = ThemeHelper.getPaletteColors(context);

    return palette.pink.light;
  }
}
