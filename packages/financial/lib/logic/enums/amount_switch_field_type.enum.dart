enum FastFinancialAmountSwitchFieldType {
  percent,
  amount,
  pip,
  price,
}

FastFinancialAmountSwitchFieldType? financialAmountSwitchFieldTypeFromString(
    String? string) {
  switch (string) {
    case 'percent':
      return FastFinancialAmountSwitchFieldType.percent;
    case 'amount':
      return FastFinancialAmountSwitchFieldType.amount;
    case 'pip':
      return FastFinancialAmountSwitchFieldType.pip;
    case 'price':
      return FastFinancialAmountSwitchFieldType.price;
    default:
      return null;
  }
}
