enum FastAmountSwitchFieldType {
  percent,
  amount,
}

FastAmountSwitchFieldType? amountSwitchFieldTypeFromString(String? string) {
  switch (string) {
    case 'percent':
      return FastAmountSwitchFieldType.percent;
    case 'amount':
      return FastAmountSwitchFieldType.amount;
    default:
      return null;
  }
}
