// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_dart/fastyle_dart.dart';

// Project imports:
import 'package:fastyle_ad/fastyle_ad.dart';

class FastAdDetails extends StatelessWidget {
  final String? descriptionText;
  final String? titleText;
  final FastAdSize adSize;
  final double? rating;

  const FastAdDetails({
    super.key,
    this.adSize = FastAdSize.medium,
    this.descriptionText,
    this.titleText,
    this.rating,
  });

  @override
  Widget build(BuildContext context) {
    final hasDescription = (adSize > FastAdSize.small &&
        descriptionText != null &&
        descriptionText!.isNotEmpty);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (titleText != null) buildHeader(),
        if (hasDescription)
          Container(
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: FastAdDescription(text: descriptionText!, adSize: adSize),
          ),
      ],
    );
  }

  Widget buildHeader() {
    if (adSize == FastAdSize.small) {
      return buildSmallHeader();
    }

    return Row(
      children: [
        FastAdTitle(text: titleText!),
        if (rating != null && rating! > 0)
          Container(
            margin: const EdgeInsets.only(left: 8),
            child: FastStarRating(
              initialRating: rating!,
              size: kFastIconSizeXxs,
              readOnly: true,
            ),
          ),
      ],
    );
  }

  Widget buildSmallHeader() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FastAdTitle(text: titleText!),
          if (rating != null && rating! > 0)
            Container(
              margin: const EdgeInsets.only(top: 8),
              child: FastStarRating(
                initialRating: rating!,
                size: kFastIconSizeXxs,
                readOnly: true,
              ),
            ),
        ],
      ),
    );
  }
}
