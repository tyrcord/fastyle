// Flutter imports:
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:tbloc/tbloc.dart';

class FastSettingsSupportLink extends StatefulWidget {
  final String? email;
  final String linkText;

  const FastSettingsSupportLink({
    Key? key,
    required this.email,
    required this.linkText,
  }) : super(key: key);

  @override
  FastSettingsSupportLinkState createState() => FastSettingsSupportLinkState();
}

class FastSettingsSupportLinkState extends State<FastSettingsSupportLink> {
  late TapGestureRecognizer _emailTapRecognizer;

  @override
  void initState() {
    super.initState();
    _emailTapRecognizer = TapGestureRecognizer();
    handleAskForSupport();
  }

  @override
  void dispose() {
    _emailTapRecognizer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bodyTextStyle = ThemeHelper.texts.getBodyTextStyle(context);
    final scaleFactor = MediaQuery.textScaleFactorOf(context);
    final palette = ThemeHelper.getPaletteColors(context);
    final blueColor = palette.blue.mid;
    final spanTextStyle = bodyTextStyle.copyWith(
      fontSize: bodyTextStyle.fontSize! * scaleFactor,
    );
    final linkTextStyle = spanTextStyle.copyWith(color: blueColor);

    return RichText(
      text: TextSpan(
        style: spanTextStyle,
        text: widget.linkText,
        children: [
          TextSpan(
            recognizer: _emailTapRecognizer,
            style: linkTextStyle,
            text: widget.email,
          ),
        ],
      ),
    );
  }

  handleAskForSupport() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final appInfoBloc = BlocProvider.of<FastAppInfoBloc>(context);
      final appInfo = appInfoBloc.currentState;

      _emailTapRecognizer.onTap = () {
        FastMessenger.askForSupport(appInfo.supportEmail!);
      };
    });
  }
}
