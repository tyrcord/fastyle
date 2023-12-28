// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:easy_localization/easy_localization.dart';
import 'package:fastyle_core/fastyle_core.dart';
import 'package:go_router/go_router.dart';
import 'package:lingua_core/generated/locale_keys.g.dart';
import 'package:tenhance/tenhance.dart';

//TODO: @need-review: code from fastyle_dart

const _kStepDotSize = 10.0;

class FastOnboardingView extends StatefulWidget {
  final FastOnboardingViewController? controller;

  ///
  /// Main widget when the application starts up.
  ///
  final String? doneRoute;
  final VoidCallback? onDone;
  final Future<void> Function(int index, Widget? child)? onNext;
  final VoidCallback? onSkip;
  final Color? stepDotColor;
  final List<Widget> slides;
  final double stepDotSize;
  final bool allowToSkip;
  final String? doneText;
  final String? nextText;
  final String? skipText;
  final String homeLocation;
  final bool enableUserScrolling;

  const FastOnboardingView({
    super.key,
    required this.slides,
    this.stepDotSize = _kStepDotSize,
    this.doneText,
    this.nextText,
    this.skipText,
    this.allowToSkip = false,
    this.stepDotColor,
    this.controller,
    this.doneRoute,
    this.onDone,
    this.onSkip,
    this.onNext,
    this.homeLocation = '/',
    this.enableUserScrolling = true,
  });

  @override
  FastOnboardingViewState createState() => FastOnboardingViewState();
}

class FastOnboardingViewState extends State<FastOnboardingView> {
  final PageController _pageViewController = PageController();
  late FastOnboardingViewController _controller;
  int _slidesLength = 0;
  int _pageCursor = 0;

  bool get hasReachEnd => _pageCursor + 1 == _slidesLength;

  @override
  void initState() {
    _controller = widget.controller ?? FastOnboardingViewController();
    _slidesLength = widget.slides.length;
    _pageViewController.addListener(() {
      if (!mounted) return;

      setState(() => _pageCursor = _pageViewController.page!.round());
    });
    super.initState();
  }

  @override
  void dispose() {
    _pageViewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final spacing = ThemeHelper.spacing.getVerticalSpacing(context);
    final themeBloc = FastThemeBloc.instance;
    final brightness = themeBloc.currentState.brightness;
    final overlayStyle = brightness == Brightness.dark
        ? SystemUiOverlayStyle.light
        : SystemUiOverlayStyle.dark;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: overlayStyle,
      child: Scaffold(
        body: SafeArea(
          child: ValueListenableBuilder(
            valueListenable: _controller,
            builder: (BuildContext context, bool isPending, Widget? child) {
              return IgnorePointer(
                ignoring: isPending,
                child: FastMediaLayoutBuilder(builder: (context, mediaType) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                        child: PageView.builder(
                          padEnds: false,
                          physics: !widget.enableUserScrolling
                              ? const NeverScrollableScrollPhysics()
                              : null,
                          controller: _pageViewController,
                          itemCount: _slidesLength,
                          itemBuilder: (BuildContext context, int index) {
                            return widget.slides[index];
                          },
                        ),
                      ),
                      _buildStepper(context, isPending),
                      if (mediaType >= FastMediaType.tablet) spacing,
                    ],
                  );
                }),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildStepper(BuildContext context, bool isPending) {
    final canShowSkipButton = widget.allowToSkip && !hasReachEnd;

    return _buildStepperContainer(
      context,
      Stack(
        children: <Widget>[
          Positioned.fill(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildSteps(context),
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: _buildButtonLayout(
              context,
              FastTextButton(
                onTap: () async {
                  if (hasReachEnd) {
                    _done(context);
                  } else {
                    await widget.onNext?.call(
                      _pageCursor,
                      widget.slides[_pageCursor],
                    );

                    _pageViewController.nextPage(
                      duration: kTabScrollDuration,
                      curve: Curves.ease,
                    );
                  }
                },
                text: hasReachEnd ? _getDoneText() : _getNextText(),
                isEnabled: !isPending,
              ),
            ),
          ),
          if (canShowSkipButton)
            _buildButtonLayout(
              context,
              FastTextButton(
                onTap: () => _onSkip(context),
                text: _getSkipText(),
              ),
            ),
        ],
      ),
    );
  }

// TODO: check
  Widget _buildStepperContainer(BuildContext context, Widget child) {
    return FastMediaLayoutBuilder(builder: ((context, mediaType) {
      var factor = 1.0;

      if (mediaType == FastMediaType.tablet) {
        factor = 0.8;
      } else if (mediaType == FastMediaType.desktop) {
        factor = 0.6;
      }

      return FractionallySizedBox(widthFactor: factor, child: child);
    }));
  }

  List<Widget> _buildSteps(BuildContext context) {
    final primaryColor =
        widget.stepDotColor ?? ThemeHelper.colors.getPrimaryColor(context);

    return List<Widget>.generate(
      _slidesLength,
      (index) => Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        height: widget.stepDotSize,
        width: widget.stepDotSize,
        decoration: BoxDecoration(
          color: _pageCursor == index
              ? primaryColor
              : primaryColor.withOpacity(0.2),
          borderRadius: BorderRadius.circular(widget.stepDotSize),
        ),
      ),
    );
  }

  Widget _buildButtonLayout(BuildContext context, Widget child) {
    final padding = ThemeHelper.spacing.getHorizontalPadding(context);

    return Padding(padding: padding, child: child);
  }

  void _onSkip(BuildContext context) {
    if (widget.onSkip != null) {
      widget.onSkip!();
    } else {
      _done(context);
    }
  }

  Future<void> _done(BuildContext context) async {
    final appInfoBloc = FastAppOnboardingBloc.instance;

    appInfoBloc.addEvent(
      const FastAppOnboardingBlocEvent.initializationCompleted(),
    );

    await appInfoBloc.onData.firstWhere((state) => state.isCompleted);

    widget.onDone?.call();

    // FIXME: use go instead of pushReplacement as a workaround to allow
    // go router to works with top level routes and shell routes.
    // users will be able to go back to the onboarding screen if they
    // press the back button on the device.
    // ISSUE: https://github.com/flutter/flutter/issues/137545

    if (mounted) GoRouter.of(context).go(widget.homeLocation);
  }

  String _getDoneText() {
    return widget.doneText ?? CoreLocaleKeys.core_label_done.tr();
  }

  String _getNextText() {
    return widget.nextText ?? CoreLocaleKeys.core_label_next_text.tr();
  }

  String _getSkipText() {
    return widget.skipText ?? CoreLocaleKeys.core_label_skip_text.tr();
  }
}
