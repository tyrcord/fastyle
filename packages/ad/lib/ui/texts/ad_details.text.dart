import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:flutter/material.dart';
import 'package:fastyle_ad/fastyle_ad.dart';

class FastAdDetails extends StatelessWidget {
  final String? descriptionText;
  final String? titleText;
  final FastAdSize adSize;

  const FastAdDetails({
    super.key,
    this.adSize = FastAdSize.medium,
    this.descriptionText,
    this.titleText,
  });

  @override
  Widget build(BuildContext context) {
    final hasDescription = (adSize > FastAdSize.small &&
        descriptionText != null &&
        descriptionText!.isNotEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (titleText != null) FastAdTitle(text: titleText!),
        if (hasDescription)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: FastAdDescription(text: descriptionText!, adSize: adSize),
          ),
      ],
    );
  }
}
