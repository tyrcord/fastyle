import 'package:fastyle_core/ui/ui.dart';
import 'package:flutter/material.dart';
import 'package:fastyle_quizz/fastyle_quizz.dart';

class FastCircleProgress extends StatelessWidget {
  final double currentProgress;
  final String? labelText;
  final double width;
  final double height;
  final Color progressColor;
  final Color backgroundColor;
  final double strokeWidth;

  const FastCircleProgress({
    super.key,
    required this.currentProgress,
    this.labelText,
    this.width = 64,
    this.height = 64,
    this.progressColor = Colors.blue,
    this.backgroundColor = Colors.grey,
    this.strokeWidth = 10,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: CustomPaint(
        foregroundPainter: FastCircleProgressPainter(
          currentProgress,
          progressColor: progressColor,
          backgroundColor: backgroundColor,
          strokeWidth: strokeWidth,
        ),
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
