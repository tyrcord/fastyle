// Package imports:
import 'package:tmodel/tmodel.dart';

// Project imports:
import 'package:fastyle_calculator/fastyle_calculator.dart';

class FastReportCategoryEntry extends TModel {
  final String name;
  final List<FastReportEntry> entries;
  final FastReportEntry? summary;

  const FastReportCategoryEntry({
    required this.name,
    required this.entries,
    this.summary,
  });

  @override
  FastReportCategoryEntry clone() => copyWith();

  @override
  FastReportCategoryEntry copyWith({
    String? name,
    List<FastReportEntry>? entries,
    FastReportEntry? summary,
  }) {
    return FastReportCategoryEntry(
      name: name ?? this.name,
      entries: entries ?? this.entries,
      summary: summary ?? this.summary,
    );
  }

  @override
  FastReportCategoryEntry merge(covariant FastReportCategoryEntry model) {
    return copyWith(
      name: model.name,
      entries: model.entries,
      summary: model.summary,
    );
  }

  @override
  List<Object?> get props => [
        name,
        entries,
        summary,
      ];
}
