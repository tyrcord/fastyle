import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:t_helpers/helpers.dart';

class Operation {
  final List<String> operands;
  final String operator;
  final String? result;

  Operation({
    required this.operands,
    required this.operator,
    this.result,
  });
}

class FastDigitCalculatorHistoryListItem extends StatelessWidget {
  final String operation;

  const FastDigitCalculatorHistoryListItem({
    Key? key,
    required this.operation,
  }) : super(key: key);

  Operation? parseOperation(String operation) {
    final operandsAndOperators = parseSimpleOperation(operation);

    if (operandsAndOperators != null) {
      final operands = operandsAndOperators[0] as List<String>;
      final operator = operandsAndOperators[1] as String;
      String? result;

      if (operandsAndOperators.length > 2) {
        result = operandsAndOperators[2] as String;
      }

      return Operation(
        operands: operands,
        operator: operator,
        result: result,
      );
    }

    return null;
  }

  List<TextSpan> _buildTextsSpan(BuildContext context, Operation operation) {
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
    final operation = parseOperation(this.operation);

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
