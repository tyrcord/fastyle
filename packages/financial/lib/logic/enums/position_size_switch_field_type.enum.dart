enum FastPositionSizeSwitchFieldType {
  unit,
  standard,
  mini,
  micro,
  nano,
}

FastPositionSizeSwitchFieldType? positionSizeSwitchFieldTypeFromString(
  String? string,
) {
  switch (string) {
    case 'unit':
      return FastPositionSizeSwitchFieldType.unit;
    case 'standard':
      return FastPositionSizeSwitchFieldType.standard;
    case 'mini':
      return FastPositionSizeSwitchFieldType.mini;
    case 'micro':
      return FastPositionSizeSwitchFieldType.micro;
    default:
      return null;
  }
}
