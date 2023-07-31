// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_images/fastyle_images.dart';

class CryptosPage extends StatelessWidget {
  const CryptosPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FastSectionPage(
      contentPadding: EdgeInsets.zero,
      isViewScrollable: true,
      titleText: 'Cryptos',
      child: FastListView(
        items: kFastImageCrypto.map((name) {
          return FastItem(
            labelText: name,
            value: name,
            descriptor: FastListItemDescriptor(
              leading: FastImageAsset(
                path: kFastImageCryptoMap[name]!,
                width: 32,
                height: 32,
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
