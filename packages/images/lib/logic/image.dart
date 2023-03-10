import 'package:flutter/widgets.dart';

class FastImageAsset extends StatelessWidget {
  final double? height;
  final double? width;
  final String path;

  const FastImageAsset({
    super.key,
    required this.path,
    this.height,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      path,
      package: 'fastyle_images',
      height: height,
      width: width,
    );
  }
}
