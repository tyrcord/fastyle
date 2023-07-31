// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:

import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

typedef UrlLinkCallback = void Function(String url);

class FastUrlLink extends StatelessWidget {
  final UrlLinkCallback onTap;
  final Color? color;
  final String text;
  final String url;

  const FastUrlLink({
    Key? key,
    required this.onTap,
    required this.text,
    required this.url,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FastLink(
      color: color,
      text: text,
      onTap: () => onTap(url),
    );
  }
}
