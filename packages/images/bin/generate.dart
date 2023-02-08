import 'dart:io';

const _assets = [
  {
    'name': 'FastImageCommodity',
    'path': 'assets/images/commodity',
    'output': 'lib/images/commodity.dart',
  },
  {
    'name': 'FastImageCrypto',
    'path': 'assets/images/crypto',
    'output': 'lib/images/crypto.dart',
  },
  {
    'name': 'FastImageFlag',
    'path': 'assets/images/flag',
    'output': 'lib/images/flags.dart',
  }
];

void main(List<String> args) async {
  for (var asset in _assets) {
    final name = asset['name']!;
    final path = asset['path']!;
    final output = asset['output']!;
    final elements = _listFiles(path);
    final buffer = StringBuffer('// Generated, do not edit\n');

    _writeClass(buffer, name, elements);
    _writeList(buffer, name, elements);
    _writeMap(buffer, name, elements);

    final file = File(output);
    file.writeAsString(buffer.toString());
  }

  _writeBarrel();
}

Map<String, String> _listFiles(String path) {
  final dir = Directory(path);
  final List<FileSystemEntity> entities = dir.listSync();
  final elements = <String, String>{};

  for (var entity in entities) {
    final stat = entity.statSync();
    final path = entity.path;

    if (stat.type == FileSystemEntityType.file && path.endsWith('.png')) {
      final name = path.split('/').last.split('.').first;

      elements.putIfAbsent(snakeCaseToCamelCase(name), () => path);
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

  for (MapEntry<String, String> entry in elements.entries) {
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

  for (MapEntry<String, String> entry in elements.entries) {
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

  for (MapEntry<String, String> entry in elements.entries) {
    final name = entry.key;

    buffer.writeln('  \'$name\': $className.$name,');
  }

  buffer.writeln('};');
}

void _writeBarrel() {
  final buffer = StringBuffer('// Generated, do not edit\n');

  buffer.writeln('library fastyle_images;\n');
  buffer.writeln('export \'logic/image.dart\';');

  for (var asset in _assets) {
    final output = asset['output']!.replaceFirst('lib/', '');

    buffer.writeln('export \'$output\';');
  }

  final file = File('lib/fastyle_images.dart');
  file.writeAsString(buffer.toString());
}

String snakeCaseToCamelCase(String snakeCase) {
  List<String> parts = snakeCase.split('_');
  var result = parts[0];

  for (int i = 1; i < parts.length; i++) {
    result += parts[i][0].toUpperCase() + parts[i].substring(1);
  }

  return result;
}
