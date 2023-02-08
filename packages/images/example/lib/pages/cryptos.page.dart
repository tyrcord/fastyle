import 'package:fastyle_images/fastyle_images.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:flutter/material.dart';

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
