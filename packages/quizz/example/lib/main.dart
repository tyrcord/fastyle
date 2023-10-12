// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_quizz/fastyle_quizz.dart';
import 'package:tenhance/tenhance.dart';
import 'package:go_router/go_router.dart';

// Project imports:
import 'package:fastyle_quizz_example/questions.dart';

void main() => runApp(const QuizApp());

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FastApp(
      routesForMediaType: (mediaType) => [
        GoRoute(
          path: '/',
          builder: (_, __) => const QuizPage(),
        ),
      ],
    );
  }
}

class QuizPage extends StatefulWidget {
  const QuizPage({super.key});

  @override
  QuizPageState createState() => QuizPageState();
}

class QuizPageState extends State<QuizPage> {
  int currentQuestionIndex = 0; // Index of the current question
  double currentScore = 0; // Current score
  int currentAnswerIndex = -1; // Index of the current answer

  int totalQuestions = 10; // Total number of questions
  List<bool> answeredCorrectly =
      List.generate(10, (index) => false); // Track answers
  bool answered = false; // Track if the current question has been answered
  bool isCorrect = false; // Track if the selected answer is correct

  double get currentProgress {
    return (currentQuestionIndex + 1) / totalQuestions * 100;
  }

  List<FastQuestion> questions = kQuestions;

  void handleAnswer(int answerIndex) {
    setState(() {
      final question = questions[currentQuestionIndex];
      isCorrect = answerIndex == question.correctIndex;
      currentAnswerIndex = answerIndex;
      answered = true;

      if (isCorrect) answeredCorrectly[currentQuestionIndex] = true;

      Future.delayed(const Duration(milliseconds: 600), () {
        if (currentQuestionIndex < totalQuestions - 1) {
          setState(() {
            currentQuestionIndex++;
            answered = false;
          });
        } else {
          // Navigate to result screen
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return FastSectionPage(
      showAppBar: false,
      child: SafeArea(
        top: false,
        bottom: true,
        child: buildLayout(),
      ),
    );
  }

  Widget buildLayout() {
    return FastMediaLayoutBuilder(
      builder: (context, mediaType) {
        final SizedBox spacer = buildSpacer(mediaType);

        return Column(
          children: [
            buildProgress(context, mediaType),
            spacer,
            Expanded(
              child: Builder(
                builder: (context) {
                  if (mediaType >= FastMediaType.tablet) {
                    return buildLandscapeLayout(context, mediaType);
                  }

                  return buildPortraitLayout(context, mediaType);
                },
              ),
            ),
            kFastSizedBox16,
          ],
        );
      },
    );
  }

  Widget buildProgress(BuildContext context, FastMediaType mediaType) {
    final palette = ThemeHelper.getPaletteColors(context).gray;
    double size = 48.0;

    if (mediaType >= FastMediaType.desktop) {
      size = 96.0;
    } else if (mediaType >= FastMediaType.tablet) {
      size = 64.0;
    }

    return FastCircleProgress(
      strokeWidth: mediaType >= FastMediaType.desktop ? 6.0 : 4.0,
      progressColor: ThemeHelper.colors.getPrimaryColor(context),
      backgroundColor: palette.lightest,
      labelText: (currentQuestionIndex + 1).toString(),
      currentProgress: currentProgress,
      height: size,
      width: size,
    );
  }

  SizedBox buildSpacer(FastMediaType mediaType) {
    SizedBox spacing = kFastSizedBox24;

    if (mediaType >= FastMediaType.desktop) {
      spacing = kFastSizedBox48;
    } else if (mediaType >= FastMediaType.tablet) {
      spacing = kFastSizedBox32;
    }

    return spacing;
  }

  Widget buildPortraitLayout(BuildContext context, FastMediaType mediaType) {
    final question = questions[currentQuestionIndex];
    final SizedBox spacer = buildSpacer(mediaType);

    return LayoutBuilder(builder: (context, constraints) {
      final maxHeight = constraints.maxHeight;

      double heightFactor = 1;

      if (maxHeight > 800) {
        heightFactor = 0.8;
      }

      return FractionallySizedBox(
        heightFactor: heightFactor,
        child: Column(
          children: [
            Expanded(child: buildMedia(context)),
            spacer,
            buildQuestion(context, mediaType),
            spacer,
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: buildAnswerOptions(
                context,
                mediaType,
                question.options,
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget buildLandscapeLayout(BuildContext context, FastMediaType mediaType) {
    final question = questions[currentQuestionIndex];

    return LayoutBuilder(builder: (context, constraints) {
      final maxHeight = constraints.maxHeight;
      double heightFactor = 1;
      double widthFactor = 1;

      if (maxHeight > 800) {
        heightFactor = 0.5;
      } else if (maxHeight > 600) {
        heightFactor = 0.65;
      } else if (maxHeight > 480) {
        heightFactor = 0.75;
      }

      if (mediaType >= FastMediaType.large) {
        widthFactor = 0.75;
      } else if (mediaType >= FastMediaType.desktop) {
        widthFactor = 0.8;
      }

      return FractionallySizedBox(
        widthFactor: widthFactor,
        heightFactor: heightFactor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: buildMedia(context)),
            kFastHorizontalSizedBox48,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: buildQuestion(context, mediaType)),
                  ...buildAnswerOptions(context, mediaType, question.options),
                ],
              ),
            )
          ],
        ),
      );
    });
  }

  Widget buildQuestion(BuildContext context, FastMediaType mediaType) {
    final question = questions[currentQuestionIndex];
    double fontSize = kFastFontSize24;

    if (mediaType >= FastMediaType.desktop) {
      fontSize = kFastFontSize40;
    } else if (mediaType >= FastMediaType.tablet) {
      fontSize = kFastFontSize34;
    }

    return ConstrainedBox(
      constraints: const BoxConstraints(minHeight: 60),
      child: Align(
        alignment: mediaType >= FastMediaType.tablet
            ? Alignment.topCenter
            : Alignment.center,
        child: FastTitle(
          textAlign: TextAlign.center,
          text: question.text,
          fontSize: fontSize,
        ),
      ),
    );
  }

  Widget buildMedia(BuildContext context) {
    final palette = ThemeHelper.getPaletteColors(context).blueGray;

    return ColoredBox(
      color: palette.ultraLight,
      child: const Center(
        child: FastSecondaryBody(text: 'Media Illustration'),
      ),
    );
  }

  List<Widget> buildAnswerOptions(
    BuildContext context,
    FastMediaType mediaType,
    List<String> options,
  ) {
    EdgeInsets padding = kFastEdgeInsets4;

    if (mediaType >= FastMediaType.desktop) {
      padding = kFastEdgeInsets8;
    } else if (mediaType >= FastMediaType.tablet) {
      padding = kFastEdgeInsets6;
    }

    return options.asMap().entries.map((entry) {
      return Padding(
        padding: padding,
        child: buildAnswerOption(
          context,
          entry.key,
          entry.value,
        ),
      );
    }).toList();
  }

  Widget buildAnswerOption(BuildContext context, int answerIndex, String text) {
    return FastRaisedButton(
      backgroundColor: _determineButtonColor(context, answerIndex),
      onTap: !answered ? () => handleAnswer(answerIndex) : null,
      text: text,
    );
  }

  Color _determineButtonColor(BuildContext context, int answerIndex) {
    if (!answered) {
      return ThemeHelper.colors.getPrimaryColor(context);
    }

    final palettes = ThemeHelper.getPaletteColors(context);

    if (currentAnswerIndex == answerIndex) {
      return isCorrect ? palettes.green.dark : palettes.red.dark;
    }

    return palettes.gray.light;
  }
}
