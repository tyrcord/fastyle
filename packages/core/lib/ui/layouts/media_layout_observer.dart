// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

// Package imports:
import 'package:tbloc/tbloc.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

//TODO: @need-review: code from fastyle_dart

class FastMediaLayoutObserver extends StatefulWidget {
  final Widget child;

  const FastMediaLayoutObserver({super.key, required this.child});

  @override
  State<StatefulWidget> createState() => _FastMediaLayoutObserverState();
}

class _FastMediaLayoutObserverState extends State<FastMediaLayoutObserver> {
  late FastMediaLayoutBloc _mediaLayoutBloc;

  @override
  void initState() {
    _mediaLayoutBloc = FastMediaLayoutBloc();
    super.initState();
  }

  @override
  void dispose() {
    _mediaLayoutBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _mediaLayoutBloc,
      child: FastMediaChangedLayoutNotifier(
        bloc: _mediaLayoutBloc,
        child: widget.child,
      ),
    );
  }
}

class FastMediaChangedLayoutNotifier extends SingleChildRenderObjectWidget {
  final FastMediaLayoutBloc bloc;

  /// Creates a [FastMediaChangedLayoutNotifier] that dispatches layout changed
  /// notifications when [child] changes layout size.
  const FastMediaChangedLayoutNotifier({
    super.key,
    super.child,
    required this.bloc,
  });

  @override
  RenderObject createRenderObject(BuildContext context) {
    return _RenderMediaLayoutChangedWithCallback(
      onLayoutChangedCallback: (FastMediaType mediaType) {
        bloc.addEvent(FastMediaLayoutBlocEvent.changed(mediaType));
      },
    );
  }
}

typedef FastMediaLayoutChangedCallback = void Function(
  FastMediaType fastMediaType,
);

class _RenderMediaLayoutChangedWithCallback extends RenderProxyBox {
  final FastMediaLayoutChangedCallback onLayoutChangedCallback;

  _RenderMediaLayoutChangedWithCallback({
    RenderBox? child,
    required this.onLayoutChangedCallback,
  }) : super(child);

  FastMediaType? _currentMediaType;

  @override
  void performLayout() {
    super.performLayout();

    var mediaType = _getFastMediaType(size);

    if (mediaType != _currentMediaType) {
      _currentMediaType = mediaType;
      onLayoutChangedCallback(mediaType);
    }
  }

  FastMediaType _getFastMediaType(Size size) {
    if (size.width >= FastMediaBreakpoints.xl) {
      return FastMediaType.xl;
    } else if (size.width >= FastMediaBreakpoints.large) {
      return FastMediaType.large;
    } else if (size.width >= FastMediaBreakpoints.desktop) {
      return FastMediaType.desktop;
    } else if (size.width >= FastMediaBreakpoints.tablet) {
      return FastMediaType.tablet;
    }

    return FastMediaType.handset;
  }
}
