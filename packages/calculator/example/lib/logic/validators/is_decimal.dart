const decimal = {'en-US': '.'};

class Options {
  final bool forceDecimal;
  final String decimalDigits;
  final String locale;

  const Options({
    this.forceDecimal = false,
    this.decimalDigits = '1,',
    this.locale = 'en-US',
  });
}

RegExp decimalRegExp(Options options) {
  final regExp = RegExp(
    "^([0-9]+)?(\\${decimal[options.locale]}[0-9]{${options.decimalDigits}})${options.forceDecimal ? '' : '?'}\$",
    multiLine: false,
    caseSensitive: false,
  );

  return regExp;
}

bool isDecimal(String str, [Options options = const Options()]) {
  if (str.isEmpty) {
    return false;
  }

  if (decimal.containsKey(options.locale)) {
    return decimalRegExp(options).hasMatch(str);
  }

  throw ArgumentError('Invalid locale ${options.locale}');
}
