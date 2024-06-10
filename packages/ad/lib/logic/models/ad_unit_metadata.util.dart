class FastAdUnitMetadata {
  final String? high;
  final String? medium;
  final String? low;
  final Map<String, String> extra;

  const FastAdUnitMetadata({
    this.high,
    this.medium,
    this.low,
    this.extra = const {},
  });

  factory FastAdUnitMetadata.fromJson(Map<String, dynamic>? json) {
    if (json == null) return const FastAdUnitMetadata();

    return FastAdUnitMetadata(
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
    return 'FastAdUnitMetadata(high: $high, medium: $medium,'
        ' low: $low, extra: $extra)';
  }
}
