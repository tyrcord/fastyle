import 'dart:developer';

import 'package:fastyle_core/fastyle_core.dart';
import 'package:flutter/material.dart';
import 'package:t_helpers/helpers.dart';

class ButtonsPage extends StatelessWidget {
  const ButtonsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FastSectionPage(
      titleText: 'Buttons',
      isViewScrollable: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          FastRaisedButton(
            text: 'raised button (platform?)',
            onTap: () {
              log('raised button tapped');

              if (isIOS) {
                log('isIOS');
              }

              if (isAndroid) {
                log('isAndroid');
              }

              if (isWeb) {
                log('isWeb');
              }

              if (isLinux) {
                log('isLinux');
              }

              if (isMacOS) {
                log('isMacOS');
              }

              if (isWindows) {
                log('isWindows');
              }

              if (isFuchsia) {
                log('isFuchsia');
              }
            },
          ),
          FastRaisedButton(
            text: 'raised button disabled',
            onTap: () {
              log('raised button disabled');
            },
            isEnabled: false,
          ),
          FastOutlineButton(
            text: 'Outline button',
            onTap: () {
              log('Outline button');
            },
          ),
          FastOutlineButton(
            text: 'Outline button disabled',
            onTap: () {
              log('Outline button disabled');
            },
            isEnabled: false,
          ),
          FastTextButton(
            text: 'Text button',
            onTap: () {
              log('text button');
            },
          ),
          FastTextButton(
            text: 'Text button disabled',
            onTap: () {
              log('text button disabled');
            },
            isEnabled: false,
          ),
          FastIconButton(
            icon: const Icon(Icons.android),
            onTap: () {
              log('icon button');
            },
          ),
          FastIconButton(
            icon: const Icon(Icons.android),
            onTap: () {
              log('icon button disabled');
            },
            isEnabled: false,
          ),
          FastIconButton(
            icon: const Icon(Icons.android),
            onTap: () {
              log('icon button disabled');
            },
            emphasis: FastButtonEmphasis.high,
          ),
        ],
      ),
    );
  }
}
