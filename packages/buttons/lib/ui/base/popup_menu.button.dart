// Flutter imports:
import 'package:fastyle_buttons/fastyle_buttons.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:fastyle_core/fastyle_core.dart';

class FastPopupMenuButton2<T> extends FastButton2 {
  /// Called when the button is pressed to create the items to show in the menu.
  final PopupMenuItemBuilder<T> itemBuilder;

  /// The value of the menu item, if any, that should be highlighted when
  final T? initialValue;

  /// Called when the popup menu is shown.
  final VoidCallback? onOpened;

  /// Called when the user selects a value from the popup menu created by this
  final PopupMenuItemSelected<T>? onSelected;

  /// Called when the user dismisses the popup menu without selecting an item.
  final PopupMenuCanceled? onCanceled;

  /// The position of the overlay relative to the button.
  final PopupMenuPosition? overlayPosition;

  /// The background color of the overlay.
  final Color? overlayBackgroundColor;

  /// The shadow color of the overlay.
  final Color? overlayShadowColor;

  /// The shape of the overlay.
  final ShapeBorder? overlayShape;

  /// The elevation of the overlay.
  final double? overlayElevation;

  /// The clip behavior of the overlay.
  final Clip overlayClipBehavior;

  /// The offset of the overlay.
  final Offset overlayOffset;

  /// The icon alignment.
  final Alignment? iconAlignment;

  /// The size of the icon.
  final double? iconSize;

  /// The color of the icon.
  final Color? iconColor;

  /// Custom icon for the button.
  final Widget icon;

  const FastPopupMenuButton2({
    super.key,
    required this.itemBuilder,
    required this.icon,
    super.trottleTimeDuration = kFastButtonTrottleTimeDuration,
    super.emphasis = FastButtonEmphasis.low,
    this.overlayClipBehavior = Clip.none,
    this.overlayOffset = Offset.zero,
    super.shouldTrottleTime = false,
    this.overlayBackgroundColor,
    this.overlayShadowColor,
    super.isEnabled = true,
    this.overlayElevation,
    this.overlayPosition,
    super.highlightColor,
    super.disabledColor,
    super.semanticLabel,
    this.iconAlignment,
    this.overlayShape,
    super.constraints,
    this.initialValue,
    super.focusColor,
    super.hoverColor,
    super.debugLabel,
    this.onSelected,
    this.onCanceled,
    this.iconColor,
    super.padding,
    super.tooltip,
    this.onOpened,
    this.iconSize,
    super.onTap,
  });

  @override
  State<FastPopupMenuButton2<T>> createState() =>
      _FastPopupMenuButtonState<T>();
}

class _FastPopupMenuButtonState<T> extends State<FastPopupMenuButton2<T>>
    with FastButtonMixin2 {
  void _handleTap() {
    showButtonMenu(context);
    widget.onTap?.call();
  }

  @override
  Widget build(BuildContext context) {
    return FastIconButton2(
      trottleTimeDuration: widget.trottleTimeDuration,
      highlightColor: widget.highlightColor,
      semanticLabel: widget.semanticLabel,
      iconAlignment: widget.iconAlignment,
      constraints: widget.constraints,
      focusColor: widget.focusColor,
      hoverColor: widget.hoverColor,
      isEnabled: widget.isEnabled,
      iconColor: widget.iconColor,
      emphasis: widget.emphasis,
      tooltip: widget.tooltip,
      padding: widget.padding,
      icon: widget.icon,
      onTap: _handleTap,
    );
  }

  void showButtonMenu(BuildContext context) {
    final popupMenuTheme = PopupMenuTheme.of(context);
    final position = _calculateMenuPosition(context, popupMenuTheme);
    final items = widget.itemBuilder(context);

    if (items.isNotEmpty) {
      widget.onOpened?.call();
      _showMenu(context, position, items, popupMenuTheme);
    }
  }

  RelativeRect _calculateMenuPosition(
    BuildContext context,
    PopupMenuThemeData popupMenuTheme,
  ) {
    final button = context.findRenderObject()! as RenderBox;
    final overlay =
        Navigator.of(context).overlay!.context.findRenderObject()! as RenderBox;
    final popupMenuPosition = widget.overlayPosition ??
        popupMenuTheme.position ??
        PopupMenuPosition.over;
    final offset = _getOffsetBasedOnPosition(popupMenuPosition, button.size);

    return RelativeRect.fromRect(
      Rect.fromPoints(
        button.localToGlobal(offset, ancestor: overlay),
        button.localToGlobal(
          button.size.bottomRight(Offset.zero) + offset,
          ancestor: overlay,
        ),
      ),
      Offset.zero & overlay.size,
    );
  }

  Offset _getOffsetBasedOnPosition(
    PopupMenuPosition popupMenuPosition,
    Size buttonSize,
  ) {
    switch (popupMenuPosition) {
      case PopupMenuPosition.over:
        return widget.overlayOffset;
      case PopupMenuPosition.under:
        final verticalPadding = widget.padding?.vertical ?? 0;
        final buttonHeight = buttonSize.height;
        final offset = Offset(0.0, buttonHeight - (verticalPadding / 2));

        return offset + widget.overlayOffset;
    }
  }

  void _showMenu(
    BuildContext context,
    RelativeRect position,
    List<PopupMenuEntry<T>> items,
    PopupMenuThemeData popupMenuTheme,
  ) {
    showMenu<T?>(
      shadowColor: widget.overlayShadowColor ?? popupMenuTheme.shadowColor,
      elevation: widget.overlayElevation ?? popupMenuTheme.elevation,
      surfaceTintColor: widget.overlayBackgroundColor ??
          ThemeHelper.colors.getSecondaryBackgroundColor(context),
      shape: widget.overlayShape ?? popupMenuTheme.shape,
      clipBehavior: widget.overlayClipBehavior,
      initialValue: widget.initialValue,
      position: position,
      context: context,
      items: items,
    ).then<void>(_handleMenuSelection);
  }

  void _handleMenuSelection(T? newValue) {
    if (!mounted) return;

    if (newValue == null) {
      widget.onCanceled?.call();
    } else {
      widget.onSelected?.call(newValue);
    }
  }
}
