import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:t_helpers/helpers.dart';

class FastDigitCalculatorHistoryListItem extends StatelessWidget {
  final String operation;

  const FastDigitCalculatorHistoryListItem({
    Key? key,
    required this.operation,
  }) : super(key: key);

  List<TextSpan> _buildTextsSpan(
      List<String> operands, List<String> operators) {
    final textSpans = <TextSpan>[];

    for (var i = 0; i < operands.length; i++) {
      final operand = operands[i];
      final isOperator = i < operators.length;

      if (isOperator) {
        final operator = operators[i];

        textSpans.add(_buildOperandTextSpan(operand));
        textSpans.add(_buildOperatorTextSpan(operator));
      } else {
        textSpans.add(_buildOperandTextSpan(operand));
      }
    }

    return textSpans;
  }

  TextSpan _buildOperatorTextSpan(String operator) {
    return TextSpan(
      style: const TextStyle(
        color: Colors.pink,
        fontWeight: FontWeight.w400,
        fontSize: 20.0,
      ),
      text: "  $operator  ",
    );
  }

  TextSpan _buildOperandTextSpan(String operand) {
    final formattedOperand = NumberFormat.decimalPattern().format(
      double.parse(operand),
    );

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
    final operandsAndOperators = parseSimpleOperation(operation);
    final operands = operandsAndOperators[0];
    final operators = operandsAndOperators[1];
    final textSpans = _buildTextsSpan(operands, operators);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 24.0,
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
}
