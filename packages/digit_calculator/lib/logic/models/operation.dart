class FastExpressionOperation {
  final List<String> operands;
  final String operator;
  final String? result;

  FastExpressionOperation({
    required this.operands,
    required this.operator,
    this.result,
  });
}
