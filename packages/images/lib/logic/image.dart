// Flutter imports:
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

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
    if (path.isEmpty) {
      return const SizedBox.shrink();
    }

    if (path.endsWith('.svg')) {
      return SvgPicture.asset(
        path,
        package: 'fastyle_images',
        height: height,
        width: width,
      );
    }

    return Image.asset(
      path,
      package: 'fastyle_images',
      height: height,
      width: width,
    );
  }
}
