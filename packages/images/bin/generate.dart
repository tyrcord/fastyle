// Dart imports:
import 'dart:io';

// Package imports:
import 'package:t_helpers/string.helper.dart';

const _assets = [
  {
    'className': 'FastImageCommodity',
    'input': 'assets/images/commodity',
    'output': 'lib/images/commodity.dart',
  },
  {
    'className': 'FastImageCrypto',
    'input': 'assets/images/crypto',
    'output': 'lib/images/crypto.dart',
  },
  {
    'className': 'FastImageFlag',
    'input': 'assets/images/flag',
    'output': 'lib/images/flags.dart',
  },
  {
    'className': 'FastImageMobile',
    'input': 'assets/images/mobile',
    'output': 'lib/images/mobile.dart',
  },
  {
    'className': 'FastImageLocalization',
    'input': 'assets/images/localizations',
    'output': 'lib/images/localizations.dart',
  }
];

void main(List<String> args) async {
  for (final asset in _assets) {
    final className = asset['className']!;
    final input = asset['input']!;
    final output = asset['output']!;
    final elements = _listFiles(input);
    final buffer = StringBuffer('// Generated, do not edit\n');

    _writeClass(buffer, className, elements);
    _writeList(buffer, className, elements);
    _writeMap(buffer, className, elements);

    File(output).writeAsString(buffer.toString());
  }

  _writeBarrel();
}

Map<String, String> _listFiles(String path) {
  final dir = Directory(path);
  final List<FileSystemEntity> entities = dir.listSync();
  final elements = <String, String>{};
  final List<String> extensions = ['.png', '.webp', '.svg.vec'];

  for (final entity in entities) {
    final stat = entity.statSync();
    final path = entity.path;

    // Check if the file has one of the specified extensions
    if (stat.type == FileSystemEntityType.file &&
        extensions.any((ext) => path.endsWith(ext))) {
      final name = path.split('/').last.split('.').first;

      elements.putIfAbsent(toCamelCase(name), () => path);
    }
  }

  return elements;
}

void _writeClass(
  StringBuffer buffer,
  String className,
  Map<String, String> elements,
) {
  buffer.writeln('class $className {\n');

  for (final MapEntry<String, String> entry in elements.entries) {
    final name = entry.key;
    final path = entry.value;

    buffer.writeln('  static const $name = \'$path\';');
  }

  buffer.writeln('}\n');
}

void _writeList(
  StringBuffer buffer,
  String className,
  Map<String, String> elements,
) {
  buffer.writeln('const k$className = [');

  for (final MapEntry<String, String> entry in elements.entries) {
    final name = entry.key;

    buffer.writeln('  \'$name\',');
  }

  buffer.writeln('];\n');
}

void _writeMap(
  StringBuffer buffer,
  String className,
  Map<String, String> elements,
) {
  buffer.writeln('const k${className}Map = {');

  for (final MapEntry<String, String> entry in elements.entries) {
    final name = entry.key;

    buffer.writeln('  \'$name\': $className.$name,');
  }

  buffer.writeln('};');
}

void _writeBarrel() {
  final buffer = StringBuffer('// Generated, do not edit\n')
    ..writeln('library fastyle_images;\n')
    ..writeln('export \'logic/logic.dart\';')
    ..writeln('export \'constants.dart\';');

  for (final asset in _assets) {
    final output = asset['output']!.replaceFirst('lib/', '');

    buffer.writeln('export \'$output\';');
  }

  File('lib/fastyle_images.dart').writeAsString(buffer.toString());
}
