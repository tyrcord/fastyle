import 'package:fastyle_calculator/fastyle_calculator.dart';
import 'package:fastyle_calculator_example/logic/logic.dart';
import 'package:fastyle_dart/fastyle_dart.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:tbloc_dart/tbloc_dart.dart';

class SumCalculatorPage extends StatefulWidget {
  const SumCalculatorPage({super.key});

  @override
  SumCalculatorPageState createState() => SumCalculatorPageState();
}

class SumCalculatorPageState extends State<SumCalculatorPage> {
  final _bloc = SumCalculatorBloc();

  final Future<String> _calculation = Future<String>.delayed(
    const Duration(seconds: 2),
    () => 'Data Loaded',
  );

  @override
  void initState() {
    super.initState();
    _bloc.addEvent(FastCalculatorBlocEvent.init<SumCalculatorResults>());
  }

  @override
  void dispose() {
    super.dispose();
    _bloc.close();
  }

  @override
  Widget build(BuildContext context) {
    return FastCalculatorPageLayout<SumCalculatorBloc, SumCalculatorResults>(
      calculatorBloc: _bloc,
      pageTitleText: 'Sum Calculator',
      requestFullApp: true,
      dividerBuilder: (BuildContext context) {
        return FutureBuilder<String>(
          future: _calculation, // a previously-obtained Future<String> or null
          builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
            if (snapshot.hasData) {
              return _buildExtra(context, 'Divider');
            }

            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 50,
                height: 50,
                child: RepaintBoundary(child: CircularProgressIndicator()),
              ),
            );
          },
        );
      },
      headerBuilder: (context) => _buildExtra(context, 'Header'),
      footerBuilder: (context) => _buildExtra(context, 'Footer'),
      fieldsBuilder: (context) {
        return Column(
          children: [
            _buildNumberAField(),
            _buildNumberBField(),
            FastExpansionPanel(
              titleText: 'Advanced',
              bodyBuilder: (BuildContext context) {
                return Column(children: [_buildAsyncField(context)]);
              },
            ),
          ],
        );
      },
      resultsBuilder: (context) {
        return Column(
          children: [_buildResults()],
        );
      },
      resultsActions: [
        FastIconButton(
          iconColor: ThemeHelper.colors.getPrimaryColor(context),
          iconAlignment: Alignment.centerRight,
          icon: const Icon(Icons.bar_chart),
          isEnabled: false,
          onTap: () {
            //TODO: Wait for fastyle_graph
          },
        )
      ],
    );
  }

  Widget _buildNumberAField() {
    return BlocBuilderWidget<SumCalculatorBloState>(
      bloc: _bloc,
      buildWhen: (SumCalculatorBloState previous, SumCalculatorBloState next) {
        var previousValue = previous.fields.numberA;
        var nextValue = next.fields.numberA;

        return previousValue != nextValue;
      },
      builder: (_, SumCalculatorBloState state) {
        var value = state.fields.numberA;

        return _buildNumberField(
          valueText: value,
          labelText: 'Number A',
          onValueChanged: (String value) {
            _patchValue('numberA', value);
          },
        );
      },
    );
  }

  Widget _buildNumberBField() {
    return BlocBuilderWidget<SumCalculatorBloState>(
      bloc: _bloc,
      buildWhen: (SumCalculatorBloState previous, SumCalculatorBloState next) {
        var previousValue = previous.fields.numberB;
        var nextValue = next.fields.numberB;

        return previousValue != nextValue;
      },
      builder: (_, SumCalculatorBloState state) {
        var value = state.fields.numberB;

        return _buildNumberField(
          valueText: value,
          labelText: 'Number B',
          onValueChanged: (String value) {
            _patchValue('numberB', value);
          },
        );
      },
    );
  }

  void _patchValue(String key, dynamic value) {
    _bloc.addEvent(FastCalculatorBlocEvent.patchValue<SumCalculatorResults>(
      key: key,
      value: value,
    ));
  }

  Widget _buildNumberField({
    required String labelText,
    required ValueChanged<String> onValueChanged,
    required String valueText,
    Widget? suffixIcon,
    bool isEnabled = true,
  }) {
    return FastNumberField(
      onValueChanged: onValueChanged,
      transformInvalidNumber: false,
      allowAutocorrect: false,
      placeholderText: '0.00',
      suffixIcon: suffixIcon,
      labelText: labelText,
      valueText: valueText,
      isEnabled: isEnabled,
      acceptDecimal: true,
    );
  }

  Widget _buildResults() {
    return BlocBuilderWidget<SumCalculatorBloState>(
      bloc: _bloc,
      buildWhen: (SumCalculatorBloState previous, SumCalculatorBloState next) {
        return previous.results.sum != next.results.sum ||
            next.isBusy != previous.isBusy;
      },
      builder: (_, SumCalculatorBloState state) {
        final sum = state.results.sum;
        final canCopy = sum.isNotEmpty && state.isValid && !state.isBusy;

        return FastPendingReadOnlyTextField(
          labelText: 'Sum',
          valueText: sum,
          isPending: state.isBusy,
          enableInteractiveSelection: canCopy,
          pendingText: '0.00',
          suffixIcon: FastIconButton(
            icon: const Icon(Icons.content_copy),
            iconAlignment: Alignment.centerRight,
            padding: EdgeInsets.zero,
            shouldTrottleTime: true,
            isEnabled: canCopy,
            onTap: () async {
              if (canCopy) {
                await Clipboard.setData(ClipboardData(text: sum));

                // ignore: use_build_context_synchronously
                if (!context.mounted) return;

                FastNotificationCenter.info(context, 'Copied to clipboard!');
              }
            },
          ),
        );
      },
    );
  }

  Widget _buildExtra(BuildContext context, String labelText,
      {bool expandVertically = false}) {
    final palette = ThemeHelper.getPaletteColors(context);

    return Container(
      color: palette.blueGray.mid,
      margin: const EdgeInsets.symmetric(vertical: 16),
      height: expandVertically ? 100 : 50,
      child: Center(
        child: FastBody(
          textColor: palette.whiteColor,
          text: labelText,
        ),
      ),
    );
  }

  Widget _buildAsyncField(BuildContext context) {
    return BlocBuilderWidget<SumCalculatorBloState>(
      bloc: _bloc,
      buildWhen: (SumCalculatorBloState previous, SumCalculatorBloState next) {
        var oldExtras = (previous.extras as SumCalculatorBlocStateExtras);
        var newExtras = (next.extras as SumCalculatorBlocStateExtras);

        return oldExtras.isFetchingAsyncValue !=
                newExtras.isFetchingAsyncValue ||
            oldExtras.asyncValue != newExtras.asyncValue;
      },
      builder: (_, SumCalculatorBloState state) {
        var extras = (state.extras as SumCalculatorBlocStateExtras);

        return _buildNumberField(
          labelText: 'Async value',
          // ignore: no-empty-block
          onValueChanged: (_) {},
          valueText: extras.asyncValue,
          isEnabled: !extras.isFetchingAsyncValue,
          suffixIcon: FastAnimatedRotationIconButton(
            isEnabled: !extras.isFetchingAsyncValue,
            iconAlignment: Alignment.centerRight,
            rotate: extras.isFetchingAsyncValue,
            padding: EdgeInsets.zero,
            onTap: () {
              _bloc.addEvent(
                  FastCalculatorBlocEvent.custom<SumCalculatorResults>(
                'async',
              ));
            },
          ),
        );
      },
    );
  }
}
