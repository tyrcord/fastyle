// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:flutter_svg/svg.dart';
import 'package:vector_graphics/vector_graphics.dart';

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

    if (path.startsWith('http')) {
      if (path.endsWith('.svg')) {
        return SvgPicture.network(
          path,
          height: height,
          width: width,
        );
      }

      return Image.network(
        path,
        height: height,
        width: width,
      );
    }

    if (path.endsWith('.svg')) {
      return SvgPicture.asset(
        path,
        package: 'fastyle_images',
        height: height,
        width: width,
      );
    }

    if (path.endsWith('.svg.vec')) {
      return SvgPicture(
        AssetBytesLoader(
          path,
          packageName: 'fastyle_images',
        ),
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
