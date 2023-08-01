// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

// Project imports:


//TODO: @need-review: code from fastyle_dart

typedef UrlLinkCallback = void Function(String url);

class FastUrlLink extends StatelessWidget {
  final UrlLinkCallback onTap;
  final Color? color;
  final String text;
  final String url;

  const FastUrlLink({
    super.key,
    required this.onTap,
    required this.text,
    required this.url,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return FastLink(
      color: color,
      text: text,
      onTap: () => onTap(url),
    );
  }
}
