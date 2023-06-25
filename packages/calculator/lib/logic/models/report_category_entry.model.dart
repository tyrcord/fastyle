import 'package:fastyle_calculator/fastyle_calculator.dart';
import 'package:tmodel/tmodel.dart';

class FastReportCategoryEntry extends TModel {
  final String name;
  final List<FastReportEntry> entries;

  const FastReportCategoryEntry({
    required this.name,
    required this.entries,
  });

  @override
  FastReportCategoryEntry clone() => copyWith();

  @override
  FastReportCategoryEntry copyWith({
    String? name,
    List<FastReportEntry>? entries,
  }) {
    return FastReportCategoryEntry(
      name: name ?? this.name,
      entries: entries ?? this.entries,
    );
  }

  @override
  FastReportCategoryEntry merge(covariant FastReportCategoryEntry model) {
    return copyWith(
      name: model.name,
      entries: model.entries,
    );
  }

  @override
  List<Object?> get props => [name, entries];
}
