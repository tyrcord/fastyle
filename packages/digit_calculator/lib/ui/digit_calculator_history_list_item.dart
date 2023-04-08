import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:t_helpers/helpers.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class FastDigitCalculatorHistoryListItem extends StatelessWidget {
  final String expression;

  const FastDigitCalculatorHistoryListItem({
    Key? key,
    required this.expression,
  }) : super(key: key);

  List<TextSpan> _buildTextsSpan(
    BuildContext context,
    TSimpleOperation operation,
  ) {
    final textSpans = <TextSpan>[];

    for (var i = 0; i < operation.operands.length; i++) {
      final operand = operation.operands[i];
      final isOperator = i == 0;

      if (isOperator) {
        textSpans.add(_buildOperandTextSpan(operand));
        textSpans.add(_buildOperatorTextSpan(context, operation.operator));
      } else {
        textSpans.add(_buildOperandTextSpan(operand));
      }
    }

    if (operation.result != null) {
      textSpans.add(_buildOperatorTextSpan(context, '='));
      textSpans.add(_buildOperandTextSpan(operation.result!));
    }

    return textSpans;
  }

  TextSpan _buildOperatorTextSpan(BuildContext context, String operator) {
    return TextSpan(
      style: TextStyle(
        color: _getPinkColor(context),
        fontWeight: FontWeight.w400,
        fontSize: 20.0,
      ),
      text: "  $operator  ",
    );
  }

  TextSpan _buildOperandTextSpan(String text) {
    final operand = double.tryParse(text);
    final formattedOperand = NumberFormat.decimalPattern().format(operand);

    return TextSpan(
      text: formattedOperand,
      style: TextStyle(
        color: Colors.grey[500],
        fontWeight: FontWeight.w400,
        fontSize: 20.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final operation = parseSimpleOperation(expression);

    if (operation != null) {
      final textSpans = _buildTextsSpan(context, operation);

      return Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 4.0,
        ),
        child: ListTile(
          dense: true,
          title: RichText(
            textAlign: TextAlign.right,
            text: TextSpan(children: textSpans),
          ),
        ),
      );
    }

    return const SizedBox();
  }

  Color _getPinkColor(BuildContext context) {
    final palette = ThemeHelper.getPaletteColors(context);
    return palette.pink.light;
  }
}
