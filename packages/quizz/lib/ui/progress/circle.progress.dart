import 'package:fastyle_core/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:fastyle_quizz/fastyle_quizz.dart';

class FastCircleProgress extends StatelessWidget {
  final double currentProgress;
  final String? labelText;
  final double width;
  final double height;

  const FastCircleProgress({
    Key? key,
    required this.currentProgress,
    this.labelText,
    this.width = 64,
    this.height = 64,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        foregroundPainter: FastCircleProgressPainter(currentProgress),
        child: buildLabel(),
      ),
    );
  }

  Widget buildLabel() {
    if (labelText != null) {
      return Center(
        child: FastBody(
          text: labelText!,
          fontWeight: kFastFontWeightSemiBold,
          fontSize: kFastFontSize24,
        ),
      );
    }

    return const SizedBox.shrink();
  }
}
