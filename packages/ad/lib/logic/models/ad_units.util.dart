class FastAdUnits {
  final String? high;
  final String? medium;
  final String? low;
  final Map<String, String> extra;

  static String getAdPriorityByIndex(int index) {
    switch (index) {
      case 0:
        return 'high';
      case 1:
        return 'medium';
      default:
        return 'low';
    }
  }

  const FastAdUnits({
    this.high,
    this.medium,
    this.low,
    this.extra = const {},
  });

  factory FastAdUnits.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const FastAdUnits();

    return FastAdUnits(
      high: json['high'] as String?,
      medium: json['medium'] as String?,
      low: json['low'] as String?,
      extra: (json['extra'] as Map<String, dynamic>? ?? {})
          .map((key, value) => MapEntry(key, value as String)),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'high': high,
      'medium': medium,
      'low': low,
      'extra': extra,
    };
  }

  @override
  String toString() {
    return 'FastAdUnits(high: $high, medium: $medium,'
        ' low: $low, extra: $extra)';
  }
}
