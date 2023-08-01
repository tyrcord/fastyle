import 'package:fastyle_core/fastyle_core.dart';
import 'package:flutter/material.dart';

class CardsPage extends StatelessWidget {
  const CardsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FastSectionPage(
      titleText: 'Cards',
      isViewScrollable: true,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          const FastCard(
            titleText: 'Empty Card',
          ),
          kFastSizedBox16,
          const FastCard(
            titleText: 'French',
            child: FastSecondaryBody(text: 'Bonjour le monde !'),
          ),
          kFastSizedBox16,
          FastCard(
            titleText: 'English',
            headerActions: <Widget>[
              FastIconButton(
                onTap: () {
                  _showPopup(context, 'Thanks!');
                },
                icon: const Icon(
                  Icons.favorite,
                ),
              ),
            ],
            child: const FastSecondaryBody(text: 'Hello World!'),
          ),
          kFastSizedBox16,
          const FastCard(
            titleText: 'Spanish',
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                FastSecondaryBody(text: 'Hola!'),
                FastSecondaryBody(text: 'Hola!'),
              ],
            ),
          ),
          kFastSizedBox16,
          FastCard(
            titleText: 'English',
            headerActions: <Widget>[
              FastIconButton(
                onTap: () {},
                icon: const Icon(
                  Icons.favorite,
                ),
              ),
            ],
            footerActions: <Widget>[
              FastTextButton(
                text: 'cancel',
                onTap: () {},
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
              ),
              FastTextButton(
                text: 'Valid',
                onTap: () {},
                emphasis: FastButtonEmphasis.high,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
              ),
            ],
            child: const FastBody(text: 'With Shadow ;)'),
          ),
          kFastSizedBox16,
          FastCard(
            titleText: 'English',
            headerActions: <Widget>[
              FastIconButton(
                onTap: () {},
                icon: const Icon(
                  Icons.favorite,
                ),
              ),
            ],
            footerActions: <Widget>[
              FastTextButton(
                text: 'cancel',
                onTap: () {},
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
              ),
              FastTextButton(
                text: 'Valid',
                onTap: () {},
                emphasis: FastButtonEmphasis.high,
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
              ),
            ],
          ),
          kFastSizedBox16,
          FastCard(
            titleText: 'Calculator',
            child: Column(
              children: [
                const FastSecondaryBody(text: 'Content 1'),
                const FastSecondaryBody(text: 'Content 2'),
                kFastSizedBox16,
                FastExpansionPanel(
                  titleText: 'More...',
                  bodyBuilder: (_) => Container(
                    height: 200,
                    color: Colors.blue,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _showPopup(BuildContext context, String message) async {
    return showFastAlertDialog(
      context: context,
      titleText: 'Action',
      messageText: message,
      onCancel: () {
        Navigator.pop(context);
      },
      onValid: () {
        Navigator.pop(context);
      },
    );
  }
}
