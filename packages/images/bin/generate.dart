import 'dart:io';

void main(List<String> args) async {
  final dir = Directory('assets/icons/flags');
  final List<FileSystemEntity> entities = await dir.list().toList();
  final file = File('lib/flags.dart');
  final names = [];

  final outputBuffer = StringBuffer('// Generated, do not edit\n');
  outputBuffer.writeln('class FastImageFlags {\n');

  entities.forEach((entity) {
    final stat = entity.statSync();

    if (stat.type == FileSystemEntityType.file) {
      final path = entity.path;
      final name = path.split('/').last.split('.').first;

      names.add(name);

      outputBuffer.writeln('  static const $name = \'$path\';');
    }
  });

  outputBuffer.writeln('}\n');

  outputBuffer.writeln('const kFastImageFlags = [');

  names.forEach((name) {
    outputBuffer.writeln('  \'$name\',');
  });

  outputBuffer.writeln('];\n');

  outputBuffer.writeln('const kFastImageFlagsMap = {');

  names.forEach((name) {
    outputBuffer.writeln('  \'$name\': FastImageFlags.$name,');
  });

  outputBuffer.writeln('};');

  file.writeAsString(outputBuffer.toString());
}
