import 'package:flutter/material.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_ad/fastyle_ad.dart';

class FastMediumNativeAdLayout extends StatelessWidget {
  final FastAdSize adSize = FastAdSize.medium;
  final String? merchantLogoUrl;
  final Widget? detailsPlaceholder;
  final VoidCallback? onButtonTap;
  final String? descriptionText;
  final String? buttonText;
  final String? titleText;
  final double? rating;
  final Widget? icon;

  const FastMediumNativeAdLayout({
    super.key,
    this.detailsPlaceholder,
    this.descriptionText,
    this.onButtonTap,
    this.buttonText,
    this.titleText,
    this.rating,
    this.icon,
    this.merchantLogoUrl,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = kFastNativeAdAssetSizes[adSize] ?? 0;

    return Row(
      children: [
        _buildNativeAdIcon(),
        kFastHorizontalSizedBox16,
        Expanded(
          child: SizedBox(
            height: iconSize,
            child: Column(
              children: [
                Expanded(child: _buildAdContent()),
                if (buttonText != null)
                  _buildAdButton()
                else if (merchantLogoUrl != null)
                  _buildMerchantLogo(),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNativeAdIcon() {
    return FastNativeAdIcon(
      alignment: Alignment.topCenter,
      adSize: adSize,
      icon: icon,
    );
  }

  Widget _buildAdButton() {
    return Align(
      alignment: Alignment.bottomRight,
      child: FastRaisedButton(
        text: buttonText!,
        onTap: onButtonTap,
      ),
    );
  }

  Widget _buildMerchantLogo() {
    return Align(
      alignment: Alignment.bottomRight,
      child: Image.network(
        merchantLogoUrl!,
        height: kFastIconSizeSmall,
      ),
    );
  }

  Widget _buildAdContent() {
    return detailsPlaceholder != null
        ? detailsPlaceholder!
        : FastAdDetails(
            maxLines: buttonText != null ? 2 : 5,
            descriptionText: descriptionText,
            titleText: titleText,
            adSize: adSize,
            rating: rating,
          );
  }
}
