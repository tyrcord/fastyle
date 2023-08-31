import 'package:example/questions.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:fastyle_quizz/fastyle_quizz.dart';
import 'package:flutter/material.dart';

void main() => runApp(const QuizApp());

class QuizApp extends StatelessWidget {
  const QuizApp({super.key});

  @override
  Widget build(BuildContext context) {
    return FastApp(
      homeBuilder: (_) => const QuizPage(),
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
        SizedBox spacer = buildSpacer(mediaType);

        return Column(
          children: [
            buildProgress(mediaType),
            spacer,
            Expanded(
              child: Builder(
                builder: (context) {
                  if (mediaType >= FastMediaType.desktop) {
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

  Widget buildProgress(FastMediaType mediaType) {
    double size = 48.0;

    if (mediaType >= FastMediaType.desktop) {
      size = 96.0;
    } else if (mediaType >= FastMediaType.tablet) {
      size = 64.0;
    }

    return FastCircleProgress(
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
    SizedBox spacer = buildSpacer(mediaType);

    return FractionallySizedBox(
      widthFactor: mediaType == FastMediaType.tablet ? 0.65 : 1,
      child: Column(
        children: [
          Expanded(child: buildMedia()),
          spacer,
          FastTitle(text: question.text, textAlign: TextAlign.center),
          spacer,
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: buildAnswerOptions(context, mediaType, question.options),
          ),
        ],
      ),
    );
  }

  Widget buildLandscapeLayout(BuildContext context, FastMediaType mediaType) {
    final question = questions[currentQuestionIndex];
    double fontSize = 24.0;

    if (mediaType >= FastMediaType.desktop) {
      fontSize = 40.0;
    } else if (mediaType >= FastMediaType.tablet) {
      fontSize = 36.0;
    }

    print('fontSize: $fontSize');

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(child: buildMedia()),
        kFastHorizontalSizedBox48,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: FastTitle(
                  textAlign: TextAlign.center,
                  text: question.text,
                  fontSize: fontSize,
                ),
              ),
              ...buildAnswerOptions(context, mediaType, question.options),
            ],
          ),
        )
      ],
    );
  }

  Widget buildMedia() {
    return ColoredBox(
      color: Colors.grey[300]!,
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
    final palettes = ThemeHelper.getPaletteColors(context);

    if (!answered) {
      return palettes.blue.mid;
    }

    if (currentAnswerIndex == answerIndex) {
      return isCorrect ? palettes.green.mid : palettes.red.mid;
    }

    return palettes.gray.mid;
  }
}
